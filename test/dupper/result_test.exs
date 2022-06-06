defmodule Dupper.ResultTest do
  use ExUnit.Case
  alias Dupper.Result

  test "add entries to result" do
    Result.add_hash("hash1", "file1")
    Result.add_hash("hash1", "file2")
    Result.add_hash("hash2", "file3")
    Result.add_hash("hash3", "file4")
    Result.add_hash("hash2", "file5")
    Result.add_hash("hash4", "file6")

    dups = Result.duplicates()

    assert length(dups) == 2

    assert ~w[file2 file1] in dups
    assert ~w[file5 file3] in dups
  end
end
