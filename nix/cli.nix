{
  perSystem =
    { pkgs, ... }:
    let
      universe = pkgs.writeShellScriptBin "universe" ''
        set -euo pipefail
        FLAKE_ROOT="''${FLAKE_ROOT:-$(pwd)}"

        usage() {
          echo "Usage: universe <command> [options]"
          echo ""
          echo "Commands:"
          echo "  rebuild     Run home-manager switch (rebuild environment)"
          echo "  service     Manage user systemd services (list|restart <unit>)"
          echo ""
          echo "Run 'universe <command> --help' for more information."
        }

        cmd_rebuild() {
          echo "==> Running home-manager switch..."
          home-manager switch --flake "$FLAKE_ROOT" "$@"
        }

        cmd_service() {
          local action="''${1:-}"
          case "$action" in
            list)
              systemctl --user list-units --type=service
              ;;
            restart)
              [[ -z "''${2:-}" ]] && echo "Usage: universe service restart <unit>" && exit 1
              systemctl --user restart "$2"
              ;;
            --help|-h)
              echo "Usage: universe service <list|restart <unit>>"
              ;;
            *)
              echo "Unknown service action: $action"
              exit 1
              ;;
          esac
        }

        case "''${1:-}" in
          rebuild)
            shift
            cmd_rebuild "$@"
            ;;
          service)
            shift
            cmd_service "$@"
            ;;
          --help|-h|"")
            usage
            ;;
          *)
            echo "Unknown command: $1"
            usage
            exit 1
            ;;
        esac
      '';
    in
    {
      packages.universe = universe // {
        meta.description = "universe CLI: rebuild & manage services";
      };
      apps.universe = {
        type = "app";
        program = "${universe}/bin/universe";
      };
    };
}
