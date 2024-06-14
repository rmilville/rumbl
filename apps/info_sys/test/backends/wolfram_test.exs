defmodule InfoSys.Backends.WolframTest do
  use ExUnit.Case, async: true

  test "makes request, reports results, then terminates" do
    actual = hd InfoSys.compute("what is elixir", [])
    assert actual.text == """
1 | noun | a sweet flavored liquid (usually containing a small amount of alcohol) used in compounding medicines to be taken by mouth in order to mask an unpleasant taste
2 | noun | hypothetical substance that the alchemists believed to be capable of changing base metals into gold
3 | noun | a substance believed to cure all ills\
"""
  end

  test "empty response reports an empty String" do
    result = InfoSys.compute("null", [])
    assert(result)
    assert hd(result).text == ""
  end

  test "no query results reports an empty list" do
    result = InfoSys.compute("error", [])
    assert(result == [])
  end

end
