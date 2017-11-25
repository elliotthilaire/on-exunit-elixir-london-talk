defmodule Library do

  def loan(user, book) do
    if Enum.empty?(user.loans) do
      loan = %Loan{user: user, book: book, due: due_date()}
      {:ok, loan}
    else
      {:error, :too_many_loans}
    end
  end

  defp due_date() do
    Date.add(Date.utc_today(), 14)
  end
end
