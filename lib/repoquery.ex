defmodule Repoquery do
  def query(repo_id, package) do
    case package_versions_info(repo_id, package) do
      {:error, error_struct} ->
        {:error, [error_struct]}
      {"Repoid" <> _, 0} ->
        {:error, ["Repo not found"]}
      {msg, exit_code} when exit_code > 0 ->
        {:error, ["#{exit_code}, #{msg}"]}
      {results, 0} ->
        {:ok, parse_info(results)}
    end
  end

  defp package_versions_info(repo_id, package) do
    try do
      System.cmd("yum", "--disablerepo=*", "--enablerepo=#{repo_id}", "clean")
      System.cmd("yum", "--disablerepo=*", "--enablerepo=#{repo_id}", "makecache")
      System.cmd("repoquery", ["--repoid=#{repo_id}", "--info", "--show-duplicates", "*#{package}*"], [stderr_to_stdout: true])
    rescue
      e in ErlangError -> {:error, e}
    end
  end

  defp parse_info(results) do
    results
    |> String.split("\n")
    |> Enum.filter_map(&relevant_metadata?/1, &extract_value/1)
    |> Enum.chunk(3)
    |> Enum.map(&mapify_list/1)
  end

  defp extract_value(str) do
    str |> String.split(": ") |> List.last
  end

  defp relevant_metadata?(str) do
    String.match?(str, ~r/Name\s+:|Version\s+:|Release\s+:/)
  end

  defp mapify_list([name, version, release]) do
    [name: name, version: version, release: release]
  end
end
