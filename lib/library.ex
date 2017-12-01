defmodule Library do

  def create_loan(user, book) do
    if Enum.empty?(user.loans) do
      due_date = date_in_14_days()
      loan = %Loan{user: user, book: book, due: due_date}

      SMSGateway.send_sms("Hello #{user.name}, #{book.title} is due on #{due_date}")

      {:ok, loan}
    else
      {:error, :too_many_loans}
    end
  end

  def end_loan(loan) do
    # if overdue

    # if not overdue
  end

  defp date_in_14_days() do
    Date.add(Date.utc_today(), 14)
  end
end
