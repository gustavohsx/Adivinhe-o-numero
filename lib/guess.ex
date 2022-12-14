defmodule Guess do
  use Application

  def start(_,_) do
    run()
    {:ok, self()}
  end

  def run() do
    IO.puts("Vamos Jogar Adivinhe o Numero!")

    IO.gets("Escolha o nivel de dificuldade (1, 2 ou 3): ")
    |> parse_input()
    |> pickup_number()
    |> play()
  end

  def play(picked_num) do
    IO.gets("Eu tenho meu numero. Qual seu palpite? ")
    |> parse_input()
    |> guess(picked_num, 1)
  end

  def guess(usr_guess, picked_num, count) when usr_guess > picked_num do
    IO.gets("Numero muito alto! Tente de novo: ")
    |> parse_input()
    |> guess(picked_num, count + 1)
  end

  def guess(usr_guess, picked_num, count) when usr_guess < picked_num do
    IO.gets("Numero muito baixo! Tente de novo: ")
    |> parse_input()
    |> guess(picked_num, count + 1)
  end

  def guess(_usr_guess, _picked_num, count) do
    IO.puts("Acertou! Precisou de #{count} tentativas!")
    show_score(count)
  end

  def show_score(guesses) when guesses > 6 do
    IO.puts("Mais sorte da proxima vez!")
  end

  def show_score(guesses) do
    {_, msg} = %{1..1 => "Voce sabe ler mentes!",
      2..4 => "Impressionante!",
      3..6 => "Voce pode fazer melhor que isso",}
      |> Enum.find(fn {range, _} ->
        Enum.member?(range, guesses)
      end)
    IO.puts(msg)
  end

  def pickup_number(nivel) do
    nivel
    |> get_range()
    |> Enum.random()
  end

  def parse_input(:error) do
    IO.puts("Entrada Invalida!")
    run()
  end

  def parse_input({num, _}), do: num

  def parse_input(data) do
    data
    |> Integer.parse()
    |> parse_input()
  end

  def get_range(nivel) do
    case nivel do
      1 -> 1..10
      2 -> 1..100
      3 -> 1..1000
      _ -> IO.puts("Nivel Invalido!")
        run()
    end
  end
end
