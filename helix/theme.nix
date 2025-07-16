let
  mkDiagnostic = color: {
    underline = {
      inherit color;
      style = "line";
    };
  };
in
{
  inherits = "rose_pine_dawn";

  diagnostic = mkDiagnostic "subtle";
  "diagnostic.hint" = mkDiagnostic "iris";
  "diagnostic.info" = mkDiagnostic "foam";
  "diagnostic.warning" = mkDiagnostic "gold";
  "diagnostic.error" = mkDiagnostic "love";
}
