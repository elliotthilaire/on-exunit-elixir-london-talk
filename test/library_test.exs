defmodule LibraryTest do
  use ExUnit.Case

  describe "loan/2 when user has no loans" do
    setup [:register_user]

    setup do
      [book: %Book{title: "Wizard and Glass"}]
    end

    test "returns {:ok, %Loan{}}", %{user: user, book: book} do
      assert {:ok, %Loan{}} = Library.loan(user, book)
    end

    test "sets due date 14 days after today", %{user: user, book: book} do
      {:ok, %Loan{due: due_date}} = Library.loan(user, book)

      assert ^due_date = Date.add(Date.utc_today(), 14)
    end
  end

  describe "loan/2 when user has loan" do
    setup [:register_user, :with_loan]

    setup do
      [book: %Book{title: "Wizard and Glass"}]
    end

    test "returns {:error, :too_many_loans}", %{user: user, book: book} do
      assert {:error, :too_many_loans} = Library.loan(user, book)
    end
  end

  defp register_user(_context) do
    user = %User{name: "Jake Chambers", loans: []}

    [user: user]
  end

  defp with_loan(%{user: user}) do
    user = %{user | loans: [%Loan{}]}

    [user: user]
  end
end
