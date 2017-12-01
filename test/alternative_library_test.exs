defmodule AlternativeLibraryTest do
  use ExUnit.Case

  describe "create_loan/2" do
    test "when user has zero loans" do
      user = %User{name: "Jake Chambers", loans: []}
      book = %Book{title: "Wizard and Glass"}

      assert {:ok, %Loan{due: due_date}} = Library.create_loan(user, book)
      assert ^due_date = Date.add(Date.utc_today(), 14)
    end

    test "when user has loan" do
      loan = %Loan{}
      user = %User{name: "Jake Chambers", loans: [loan]}
      book = %Book{title: "Wizard and Glass"}

      assert {:error, :too_many_loans} = Library.create_loan(user, book)
    end
  end
end
