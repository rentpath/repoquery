defmodule Repoquery.Mixfile do
  use Mix.Project

  def project do
    [app: :repoquery,
     version: "0.0.2",
     elixir: "~> 1.0",
     description: description,
     package: package,
     deps: deps]
  end

  def application do
    []
  end

  defp deps do
    []
  end

  defp description do
    """
    An Elixir interface for the `repoquery` cli tool.
    """
  end

  defp package do
    [
     files: ["lib", "mix.exs", "README.md", "LICENSE"],
     contributors: ["Colin Rymer"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/rentpath/repoquery"}]
  end
end
