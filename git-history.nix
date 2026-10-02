{
  lib,
  python3Packages,
  fetchPypi,
}:
python3Packages.buildPythonApplication rec {
  pname = "git-history";
  version = "0.8";
  pyproject = true;

  src = fetchPypi {
    pname = "git_history";
    inherit version;
    hash = "sha256-+HJzjS+ShQWacTZFd3PWUwXydswMVkj4bM/kWKiFjh4=";
  };

  build-system = [ python3Packages.setuptools ];

  dependencies = with python3Packages; [
    click
    gitpython
    sqlite-utils
  ];

  pythonImportsCheck = [ "git_history" ];

  meta = {
    description = "Tools for analyzing Git history using SQLite";
    homepage = "https://github.com/simonw/git-history";
    license = lib.licenses.asl20;
    mainProgram = "git-history";
  };
}
