#Attribution goes to => forums.pragprog.com, github.com, elixir-lang.org

defmodule Calc do
   #Regex for parenthesis
   @regexp ~r/\(([^()]+)\)/

   #Fetch input from console, evaluate and print
   def main() do
      case IO.gets("expression: ") do
         :eof ->
            IO.puts "All done"
         {:error, reason} ->
            IO.puts "Error: #{reason}"
         line ->
            IO.puts eval(line)
            main()
      end
   end

   #Evaluates value of input arithematic expression
   def eval(str) do
      "(#{str})"  
      |> String.replace(" ","") 
      |> calculate(:expr)
   end

   #Parsing the data
   def calculate(expression, :no_expr), do: expression
   def calculate(expression, :expr) do
    calculate(compute_part(expression), _expr?(@regexp, expression))
   end
   
   #Performing computation based on the part of expression
   def computation(part, :done), do: part
   def computation(part, :start), do: computation(part, "*", :next)
   def computation(part, op, :next) do
     computation(part, op, _expr?(op_to_regex(op), part))
   end
   def computation(part, op,  :expr), do: computation(compute_eq(part, op), op, :next)

   #Artithmatic evaluation
   def computation(part, "*", :no_expr), do: computation(part, "/", :next)
   def computation(part, "/", :no_expr), do: computation(part, "+", :next)
   def computation(part, "+", :no_expr), do: computation(part, "-", :next)
   def computation(part, "-", :no_expr), do: computation(part, :done)

   def op_to_regex(op) do
    {:ok, regexp} = Regex.compile("(\\d+)(\\#{op})(\\d+)")
    regexp
   end

   def compute_part(expression) do
    Regex.replace(@regexp, expression, fn _, part ->
      computation(part, :start)
    end)
   end

   def compute_eq(part, op) do
    op_to_regex(op)
    |> Regex.replace(part, fn _, l, op, r -> "#{compute({to_int(l), op, to_int(r)})}" end)
   end

   #Setting value of operators and expression
   def compute({left, op, right}) do
    Kernel
    |> apply(String.to_atom(op), [left, right])
    |> round
   end

   def _expr?(regex, part) do
    case Regex.match?(regex, part) do
      true -> :expr
      false -> :no_expr
    end
   end

   def to_int str do
    case Integer.parse(str) do
      {int, _ } -> int
    end
   end
end 
