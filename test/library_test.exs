defmodule LibraryTest do
  use ExUnit.Case

  import Fixtures

  describe "create_loan/2" do
    setup do
      [user: fixture(:user), book: fixture(:book)]
    end

    test "returns {:ok, %Loan{}}", %{user: user, book: book} do
      assert {:ok, %Loan{}} = Library.create_loan(user, book)
    end

    test "sets due date 14 days after today", %{user: user, book: book} do
      {:ok, %Loan{due: due_date}} = Library.create_loan(user, book)

      assert due_date == Date.add(Date.utc_today(), 14)
    end

    test "sends sms with book title and due date", %{user: user, book: book} do
      Library.create_loan(user, book)

      assert_receive({:sms_sent, sms_content})
      assert sms_content =~ book.title
      assert sms_content =~ "#{Date.add(Date.utc_today(), 14)}"
    end
  end

  describe "create_loan/2 when user has overdue loan" do
    setup do
      user = fixture(:user)
      loan = fixture(:loan, %{user: user, due: Date.add(Date.utc_today(), -2)})

      [user: %{user | loans: [loan]}]
    end

    setup do
      [book: fixture(:book)]
    end

    test "returns {:error, :too_many_loans}", %{user: user, book: book} do
      assert {:error, :too_many_loans} = Library.create_loan(user, book)
    end
  end

  describe "end_loan/1 when not overdue" do
    test "returns :ok"
  end

  describe "end_loan/1 when overdue" do
    test "returns :ok"
    test "sends sms with fine amount"
  end
end
