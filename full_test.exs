defmodule LibraryTest do
  use ExUnit.CaseTemplate

  describe "lend/2 when user has zero loans"
    setup do
      user = %User{loans: []}
      book = %Book{title: "The Gunslinger"}

      [user: user, book: book]
    end

    test "returns :ok with %Loan{}", %{user: user, book: book} do
      assert {:ok, %Loan{}} = Library.lend(user, book)
    end

    test "due date is set for 14 days from today", %{user: user, book: book} do
      {:ok, %Loan{due_date: date}} = Library.lend(user, book)

      assert ^due_date = Date.add(Date.utc_today(), 14)
    end
  end

  describe "lend/2 when user has 3 or more books loaned"
    setup do
      user =
        %User{
          loans: [
            %Loan{book: %Book{title: "The Gunslinger"}, ... },
            %Loan{book: %Book{title: "The Drawing of the Three"}, ... },
            %Loan{book: %Book{title: "The Waste Lands"}, ... }
          ]
        }

      book = %Book{title: "Wizard and Glass"}

      [user: user, book: book]
    end

    test "returns :error with :maximum_limit", %{user: user, book: book} do
      assert {:error, :maximum_limit} = Library.lend(user, book)
    end
  end

  describe "return/2"
    setup do
      user = %User{id: 1, on_loan: []}
      book = %Book{title: "The Gunslinger"}

      [user: user, book: book]
    end

    test "returns ok with loan" %{user: user, book: book} do
      result = Library.lend(user, book)

      assert {:ok, %Loan{}} = result
      assert date =
    end

    test "due date is set for three " %{user: user, book: book} do
      result = Library.lend(user, book)

      assert {:ok, %Loan{}} = result
      assert date =
    end
  end
end
