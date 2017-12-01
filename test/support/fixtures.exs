defmodule Fixtures do

  def fixture(name, attr \\ %{})

  def fixture(:user, attr) do
    %User{name: "Jake Chambers", loans: []}
    |> Map.merge(attr)
  end

  def fixture(:book, attr) do
    %Book{title: "The Gunslinger"}
    |> Map.merge(attr)
  end

  def fixture(:loan, attr) do
    %Loan{user: fixture(:user), book: fixture(:book), due: in_14_days() }
    |> Map.merge(attr)
  end

  defp in_14_days do
    Date.add(Date.utc_today(), 14)
  end
end
