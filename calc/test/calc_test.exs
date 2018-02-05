defmodule CalcTest do
  use ExUnit.Case
  doctest Calc

  test "calculator" do
  	assert Calc.eval("2 + 3") == "5"
	assert Calc.eval("5 * 1") == "5"
	assert Calc.eval("20 / 4") == "5"
	assert Calc.eval("24 / 6 + (5 - 4)") == "5"
	assert Calc.eval("2 * 2") == "4"
	assert Calc.eval("(1 + 2) * (2 + 4) / (1 + 2)") == "6"
  end
end
