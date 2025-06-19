import kitty.fast_data_types as f


def main(args: list[str]) -> str:
    # It appears that main has to return something; that's were the empty string comes from.
    # Making this function empty with `pass` doesn't seem to work
    return ""


def handle_result(args, answer, target_window_id, boss):
    os_window_id = f.current_focused_os_window_id()
    current_opacity = f.background_opacity_of(os_window_id)

    if current_opacity is None:
        current_opacity = 0.75

    new_opacity = "1" if current_opacity == 0.75 else "0.75"
    boss.set_background_opacity(new_opacity)
