
# Growing your tests with ExUnit

```elixir
defmodule MyModuleTest do
  use ExUnit.Case

  test "the_truth" do
    assert true
  end
end
```

###### @elliotthilaire

Note:
* I'm going to talk about ExUnit and how I organize tests so that they can grow as a project grows.

---

```
Module
  Function
    Scenario
      Behaviour
```

Note:
* Tests fit this hierarchy.
* Module, Function, Scenario, Behaviour
* Every level can have multiple things.
* Sometimes the level is implicit and doesn't need specific mention in a test.

---

```
Library
  create_loan(user, book)
    creates and returns a new loan
```

Note:
* I'm going to use a Library as an example
* create_loan takes a user and a book and creates a loan
* But there is an implicit scenario.
* Sometimes when you go to the library you can't take out a new loan.

---

```
Library
  create_loan(user, book)
    when user has no overdue loans
      creates and returns a new loan
```

Note:
* we have slotted the scenario straight into the hierarchy
* "Create loan, creates and returns a new loan, when the user has no overdue loans"


---

Note:
* Ah. Stop! When I describe the previous slide I said:
* "Create loan creates and returns a new loan when the user has no overdue loans"

---

```
Module
  Function
        Behaviour
    Scenario
```

Note:
* I did said something like this
* It is awkward to say "create_loan, when the user has no overdue loans, will save a new loan"
* Keep this in mind, I'm going to come back it.


---

```
Library
  create_loan(user, book)
    when user has no overdue loans
      creates and returns a new loan
```

Note:
* Back to our Library example hierarchy

---

```
Library
  create_loan(user, book)
    when user has no overdue loans
      returns a new loan

    when user has overdue loan
      returns an error
```

Note:
* So we have another scenario

---

```
Library
  create_loan(user, book)
    when user has no overdue loans
      returns a new loan
      sets the due date
      sends an sms with title and due date

    when user has overdue loan
      returns an error
```

Note:
* Lets add some more behaviour
* test the due date for 14 days away
* And that it sends an sms

---

```
Library
  create_loan/2
    when user has no overdue loans
      returns {:ok, loan}
      sets the due date
      sends an sms with title and due date

    when user has overdue loan
      returns an error

  end_loan/1
    returned in time
      returns :ok
    returned late
      returns :ok
      sends sms with fine
```

Note:
* Let's add a function for returning books

---

```
Library
  create_loan/2
    when user has no overdue loans
      returns {:ok, loan}
      sets the due date
      sends an sms with title and due date

    when user has overdue loan
        returns an error

    when staff user has no overdue loans
      returns {:ok, loan}
      sets the due date
      does not send an sms

  end_loan/1
    returned in time
      returns :ok
    returned late
      returns :ok
      sends sms with fine
```

Note:
* And what about the scenario that staff users can still borrow books even if they have an overdue book.
* We can keep adding more scenarios and behaviour, and sharing setup if we stick to the hierarchy.
* By now you might be thinking...
---

```elixir
defmodule ModuleNameTest do
  use ExUnit.Case

  describe "function/1 when scenario" do
    setup [:setup_user, ...] # shared setup

    setup do
     ... # setup specific to scenario
    end

    test "describe primary behaviour", %{user: user, ...} do
      ... # action
      ... # assertions
    end

    test "describe secondary behaviour", %{user: user, ...} do
      ... # action
      ... # assertions
    end
  end

  defp setup_user(_context) do
    ...

    [user: user]
  end
end
```
@[4](function, scenario)
@[5-9]
@[11-14](behaviour)
@[16-19]

Note:
* This is what I do
* In the describe, name the function and scenario
* Use setup callbacks, if needed
* Name the behaviour

---

```elixir
defmodule LibraryTest do
  use ExUnit.Case

  describe "create_loan/2 when user has no loans" do
    setup [:setup_user]

    setup do
      [book: %Book{title: "Wizard and Glass"}]
    end

    test "returns {:ok, %Loan{}}", %{user: user, book: book} do
      assert {:ok, %Loan{}} = Library.loan(user, book)
    end

    test "sets the due date 14 days after today", %{user: user, book: book} do
      {:ok, %Loan{due: due_date}} = Library.loan(user, book)

      assert due_date == Date.add(Date.utc_today(), 14)
    end
  end

  defp setup_user(_context) do
    user = %User{name: "Jake Chambers", loans: []}

    [user: user]
  end
end
```

@[4]
@[5-9]
@[10-13]
@[14-18]
@[22-26]

Note:
* And our library example
* What's the alternative

---

```elixir
defmodule LibraryTest do
  use ExUnit.Case

  describe "create_loan/2" do
    test "sets due date in 14 days when user has zero loans" do
      user = %User{name: "Jake Chambers", loans: []}
      book = %Book{title: "Wizard and Glass"}

      {:ok, %Loan{due: due_date}} = Library.create_loan(user, book)

      assert due_date == Date.add(Date.utc_today(), 14)
    end
  end
end
```

Note:
* take this example
* It reads naturally, but it's flipped that Module, Function, Scenario, Behaviour hierarchy.

---

Note:
* There's a deliberate decision in ExUnit to limit the amount of nesting.
* In other testing frameworks there's context block or you can nest describe blocks.
* The setup callback is much better than deeply nested tests but it leaves no natural place to name the scenario.

---

#### setup

Note:
* I'm going to talk about the setup callback.

---

```elixir
test "the context", context do
  IO.inspect context
end
```

Note:
* Every test is given an argument, called the context.

---

```elixir
%{
  async: false,
  case: MyModuleTest,
  describe: nil,
  file: ".../On ExUnit/test/my_module_test.exs",
  line: 22,
  registered: %{},
  test: :"test the context",
  type: :test
}
```

Note:
* It is a map
* And includes some information about the test.
* And like a Plug conn, you can transform it and add data to it.

---

```elixir
setup do
  [book: %Book{title: "The Wastelands"}]
end
```
```elixir
%{
  async: false,
  book: %Book{title: "The Wastelands"},
  case: MyModuleTest,
  describe: nil,
  file: ".../On ExUnit/test/context_test.exs",
  line: 26,
  registered: %{},
  test: :"test the context",
  type: :test
}
```

Note:
* When a setup callback returns a map or a list, it's merged into the context map

---

```elixir
test "returns {:ok, %Loan{}}", %{book: book} do
  ...
end
```

Note:
* You can use pattern matching to extract values from it

---

```elixir
setup [:staff_user, :sign_in,]
```

```elixir
setup [:regular_user, :sign_in]
```

```elixir
setup [:regular_user, :ban_user, :sign_in]
```

Note:
* You can pass a list of atoms and compose the setup
* This is much better than lots of nesting

---

#### Experimenting

Note:
* I started experimenting and this is what I found. I'm not sure how useful this is.
* But it might give you some insight into how tests work.

---

```bash
mix test --trace
```

```bash
LibraryTest
  * test loan/2 when user has no loans returns {:ok, %Loan{}} (9.0ms)
  * test loan/2 when user has no loans sets due date 14 days after today (0.04ms)
  * test loan/2 when user has loan returns {:error, :too_many_loans} (0.01ms)
```

Note:
* If you run `mix test --trace` you get a list that is a combination of the describe and test names
* It shows the heirachy but it's a but awkward to read.

---

```bash
iex -S app.start
```

```elixir
ExUnit.start()

import_file("test/library_test.exs")

context = %{
 user: %User{name: "Eddie Dean", loans: []},
 book: %Book{title: "Song of Susannah"}
}

LibraryTest."test create_loan/2 returns {:ok, %Loan{}}"(context)

:ok
```

Note:
* ExUnit will combine the describe name, and test name to create a function.
* If you start up your app, and load your test files, you can construct a context and run your tests interactively.

---

```elixir
iex(8)> LibraryTest."test create_loan/2 returns {:ok, %Loan{}}"(context)

** (ExUnit.AssertionError)

match (=) failed
code:  assert {:ok, %Loan{}} = Library.create_loan(user, book)
right: {:error, :overdue_loan}
```

---

Note:
* OK, so the main point.
* When your writing tests in ExUnit

---

```
Module
  Function
    Scenario
      Behaviour
```

Note:
* Pay attention to if you are writing this

---

```
Module
  Function
      Behaviour
    Scenario
```

Note:
* Or this
* So that you can don't have to spend as much time rearranging
