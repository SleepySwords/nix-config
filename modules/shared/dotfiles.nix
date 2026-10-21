{ localEditing ? false }:
{ config, inputs, ... }:
{
    xdg.configFile = if localEditing then {
        "nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/stuff/dev/dotfiles/nvim";
    } else {
        "nvim".source = "${inputs.dotfiles}/nvim";
    };
}
