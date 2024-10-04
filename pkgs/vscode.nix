{ lib, jupyter, vscode, vscode-extensions, vscode-with-extensions, vscode-utils, texlive, symlinkJoin, makeWrapper }:
symlinkJoin {
  name = "vscode-custom";
  postBuild = ''
    ln -s $out/bin/code-insiders $out/bin/code
  '';
  paths = [
    (vscode-with-extensions.override {
      vscode = (vscode.override { isInsiders = true; }).overrideAttrs (_: rec {
        pname = "vscode-insiders";
        version = "nightly";
        src = builtins.fetchurl {
          name = "VSCode_latest_linux-x64.tar.gz";
          url = "https://az764295.vo.msecnd.net/insider/9ecd3fc3022e8c154aff868f74bd5d77f7d4a2ea/code-insider-x64-1614078105.tar.gz";
          sha256 = "1qn84qc1cvprrhhgpaj7nkrsixs11k9n9xvkljai6x9plq2w91my";
        };
      });
      vscodeExtensions = with vscode-extensions; [
        ms-vscode.cpptools
        matklad.rust-analyzer
        jnoortheen.nix-ide
      ] ++ vscode-utils.extensionsFromVscodeMarketplace
        [
          {
            name = "vscode-direnv";
            publisher = "rubymaniac";
            version = "0.0.2";
            sha256 = "sha256-TVvjKdKXeExpnyUh+fDPl+eSdlQzh7lt8xSfw1YgtL4=";
          }
          {
            # One Dark Pro
            name = "Material-theme";
            publisher = "zhuangtongfa";
            version = "3.9.12";
            sha256 = "sha256-D1CpuaCZf1kkpc+le2J/prPrOXhqDwtphVk4ejtM8AQ=";
          }
          {
            name = "better-toml";
            publisher = "bungcip";
            version = "0.3.2";
            sha256 = "08lhzhrn6p0xwi0hcyp6lj9bvpfj87vr99klzsiy8ji7621dzql3";
          }
          {
            name = "rainbow-brackets";
            publisher = "2gua";
            version = "0.0.6";
            sha256 = "sha256-TVBvF/5KQVvWX1uHwZDlmvwGjOO5/lXbgVzB26U8rNQ=";
          }
        ];
    })
  ];
}