#!/usr/bin/env python3
"""Spotify player metadata fetcher and formatter for status bar integration.

This script uses the Playerctl library to monitor MPRIS-compatible media players
(such as Spotify), extract metadata like artist and title, and output a JSON
string suitable for use in a status bar. It supports filtering specific players,
excluding others, and shows dynamic output based on playback state.
"""

import argparse
import json
import logging
import os
import signal
import sys
import threading
import time
from typing import List

import gi
gi.require_version("Playerctl", "2.0")
from gi.repository import GLib, Playerctl
from gi.repository.Playerctl import Player

logger = logging.getLogger(__name__)


def signal_handler(sig, frame):
    """Handles termination signals and gracefully exits the program."""
    logger.info("Received signal to stop, exiting")
    sys.stdout.write("\n")
    sys.stdout.flush()
    sys.exit(0)


class PlayerManagerConfig:
    """Helper class to the `PlayerManager` to contain its config."""

    def __init__(self) -> None:
        """
        Initialize the PlayerManager.
        """
        self.scroll_width: int = 36
        self.scroll_delay: float = 0.5
        self.scroll_step: int = 1
        self.scroll_threads = {}
        self.last_metadata = {}  # player name -> last track info string


class PlayerManager:
    """Manages media players using Playerctl and displays metadata."""

    def __init__(self, selected_player=None, excluded_player=[], only_show_icon=False):
        """
        Initialize the PlayerManager.

        Args:
            selected_player (str): Optional player name to filter by.
            excluded_player (str): Comma-separated list of players to exclude.
        """
        self.manager = Playerctl.PlayerManager()
        self.loop = GLib.MainLoop()
        self.manager.connect(
            "name-appeared", lambda *args: self.on_player_appeared(*args))
        self.manager.connect(
            "player-vanished", lambda *args: self.on_player_vanished(*args))

        signal.signal(signal.SIGINT, signal_handler)
        signal.signal(signal.SIGTERM, signal_handler)
        signal.signal(signal.SIGPIPE, signal.SIG_DFL)

        self.selected_player = selected_player
        self.excluded_player = excluded_player.split(
            ',') if excluded_player else []

        self.config = PlayerManagerConfig()
        self.only_show_icon = only_show_icon

        self.init_players()

    def init_players(self):
        """Initialize and register existing players."""
        for player in self.manager.props.player_names:
            if player.name in self.excluded_player:
                continue
            if self.selected_player is not None and self.selected_player != player.name:
                logger.debug(
                    f"{player.name} is not the filtered player, skipping it")
                continue
            self.init_player(player)

    def run(self):
        """Run the main event loop."""
        logger.info("Starting main loop")
        self.loop.run()

    def init_player(self, player):
        """
        Initialize a specific player, connect signals, and display metadata.

        Args:
            player: A Playerctl player object.
        """
        logger.info(f"Initialize new player: {player.name}")
        player = Playerctl.Player.new_from_name(player)
        player.connect("playback-status",
                       self.on_playback_status_changed, None)
        player.connect("metadata", self.on_metadata_changed, None)
        self.manager.manage_player(player)
        self.on_metadata_changed(player, player.props.metadata)

    def get_players(self) -> List[Player]:
        """Return the current list of managed players."""
        return self.manager.props.players

    def write_output(self, text, tooltip, player):
        """
        Output formatted JSON with metadata for the status bar.

        Args:
            text (str): The main output text.
            tooltip (str): Text shown on hover.
            player (Player): The media player associated with the output.
        """
        logger.debug(f"Writing output: {text}")
        output = {
            "text": text,
            "tooltip": tooltip,
            "class": "custom-" + player.props.player_name,
            "alt": player.props.player_name
        }
        sys.stdout.write(json.dumps(output) + "\n")
        sys.stdout.flush()

    def clear_output(self):
        """Clear the output (e.g., when no player is active)."""
        sys.stdout.write("\n")
        sys.stdout.flush()

    def on_playback_status_changed(self, player, status, _=None):
        """
        Callback triggered when a player's playback status changes.

        Args:
            player (Player): The media player whose status changed.
            status (str): New playback status.
        """
        logger.debug(
            f"Playback status changed for player {player.props.player_name}: {status}")
        self.on_metadata_changed(player, player.props.metadata)

    def get_first_playing_player(self):
        """
        Return the first player that is actively playing, if any.

        Returns:
            Player or None: The currently playing player, or fallback if none.
        """
        players = self.get_players()
        logger.debug(
            f"Getting first playing player from {len(players)} players")
        if len(players) > 0:
            for player in reversed(players):
                if player.props.status == "Playing":
                    return player
            return players[0]
        else:
            logger.debug("No players found")
            return None

    def show_most_important_player(self):
        """
        Display metadata for the most relevant player (prefer playing).
        """
        logger.debug("Showing most important player")
        current_player = self.get_first_playing_player()
        if current_player is not None:
            self.on_metadata_changed(
                current_player, current_player.props.metadata)
        else:
            self.clear_output()

    def scroll_text(self, full_text: str, tooltip: str, player):
        """Starts a scrolling thread to display track info that exceeds the width limit."""
        name = player.props.player_name

        # Check if we're already scrolling the same content
        if self.config.last_metadata.get(name) == full_text:
            return

        # Save new metadata
        self.config.last_metadata[name] = full_text

        # Stop old thread if it exists
        old_thread = self.config.scroll_threads.get(name)
        if old_thread is not None and old_thread.is_alive():
            self.config.scroll_threads[name] = None

        def loop():
            padded = full_text + "   "
            logger.debug(f"Starting scroll loop for {name}")
            while self.config.last_metadata.get(name) == full_text:
                for i in range(0, len(padded) - self.config.scroll_width + 1, self.config.scroll_step):
                    if self.config.last_metadata.get(name) != full_text:
                        logger.debug(f"Scroll loop exiting for {name}")
                        return
                    visible = padded[i:i+self.config.scroll_width]
                    self.write_output(visible, tooltip, player)
                    time.sleep(self.config.scroll_delay)

        thread = threading.Thread(target=loop, daemon=True)
        self.config.scroll_threads[name] = thread
        thread.start()

    def on_metadata_changed(self, player, metadata, _=None):
        """
        Callback triggered when player metadata changes.

        Args:
            player (Player): The media player with new metadata.
            metadata (dict): Metadata dictionary.
        """
        logger.debug(f"Metadata changed for player {player.props.player_name}")
        player_name = player.props.player_name
        artist = player.get_artist()
        title = player.get_title()
        tooltip = ""

        if player_name == "spotify" and "mpris:trackid" in metadata.keys() and ":ad:" in player.props.metadata["mpris:trackid"]:
            track_info = "Advertisement"
        elif artist is not None and title is not None:
            tooltip = f"{artist} — {title}"
            track_info = f"{artist} — {title}"
        else:
            track_info = title or ""

        if track_info:
            # icon = "" if player.props.status == "Playing" else ""
            # track_info = f"{icon}   {track_info}"
            icon = "" if player.props.status == "Playing" else ""
            if self.only_show_icon:
                track_info = f"{icon}"  # icon + Spotify logo
            else:
                # Only text
                pass  # don't prepend icon

        current_playing = self.get_first_playing_player()
        if current_playing is None or current_playing.props.player_name == player.props.player_name:
            name = player.props.player_name

            if len(track_info) <= self.config.scroll_width:
                # Stop scrolling if it was active
                old_thread = self.config.scroll_threads.get(name)
                if old_thread is not None and old_thread.is_alive():
                    self.config.scroll_threads[name] = None

                self.config.last_metadata[name] = None  # Clear scroll state
                self.write_output(track_info, tooltip, player)
            else:
                self.scroll_text(track_info, tooltip, player)
        else:
            logger.debug(
                f"Other player {current_playing.props.player_name} is playing, skipping")

    def on_player_appeared(self, _, player):
        """
        Callback triggered when a new player appears.

        Args:
            player: A newly detected player.
        """
        logger.info(f"Player has appeared: {player.name}")
        if player.name in self.excluded_player:
            logger.debug(
                "New player appeared, but it's in exclude player list, skipping")
            return
        if player is not None and (self.selected_player is None or player.name == self.selected_player):
            self.init_player(player)
        else:
            logger.debug(
                "New player appeared, but it's not the selected player, skipping")

    def on_player_vanished(self, _, player):
        """
        Callback triggered when a player disappears.

        Args:
            player: The player that vanished.
        """
        logger.info(f"Player {player.props.player_name} has vanished")

        name = player.props.player_name
        # Stop any active scroll thread
        old_thread = self.config.scroll_threads.get(name)
        if old_thread is not None and old_thread.is_alive():
            self.config.last_metadata[name] = None  # Invalidate scrolling
            self.config.scroll_threads[name] = None  # Clear the thread ref

        self.show_most_important_player()


def parse_arguments():
    """
    Parse command-line arguments.

    Returns:
        argparse.Namespace: Parsed arguments.
    """
    parser = argparse.ArgumentParser()
    parser.add_argument("-v", "--verbose", action="count", default=0)
    parser.add_argument("-x", "--exclude",
                        help="Comma-separated list of excluded players")
    parser.add_argument(
        "--player", help="Only display metadata for this specific player")
    parser.add_argument("--enable-logging", action="store_true")
    parser.add_argument("--only-show-icon", action="store_true",
                        help="Only display the icon, no text")

    return parser.parse_args()


def main():
    """Main entry point for the script."""
    arguments = parse_arguments()
    if arguments.enable_logging:
        logfile = os.path.join(os.path.dirname(
            os.path.realpath(__file__)), "media-player.log")
        logging.basicConfig(filename=logfile, level=logging.DEBUG,
                            format="%(asctime)s %(name)s %(levelname)s:%(lineno)d %(message)s")

    logger.setLevel(max((3 - arguments.verbose) * 10, 0))

    logger.info("Creating player manager")
    if arguments.player:
        logger.info(f"Filtering for player: {arguments.player}")
    if arguments.exclude:
        logger.info(f"Exclude player {arguments.exclude}")

    player = PlayerManager(
        arguments.player, arguments.exclude, arguments.only_show_icon)
    player.run()


if __name__ == "__main__":
    main()
