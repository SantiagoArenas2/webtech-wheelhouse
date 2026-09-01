# Lab 3 — Wheelhouse: From a Paragraph to a Specification

**Monday, August 24** · Covers Class 3 · Learning Outcome 2

## Objective

You are given a prose description of a system. This lab turns it into the three artifacts a team can
build from: user stories, a domain model, and a set of screens.

No code is written in this lab. From Lab 4 to Lab 14 you will build **Wheelhouse**, and you will
build it from the model you produce today.

## The system

Wheelhouse is a neighbourhood bicycle repair shop. The owner describes it like this:

> We fix bikes. Someone walks in, we write their name and phone on a paper tag, tie it to the
> handlebars, and put the bike on the rack. Then it depends. Sometimes it is a flat tyre and it goes
> out the same afternoon. Sometimes we have to look at it properly, call the person, tell them what
> it will cost, and wait for them to say yes before we touch it. Most people say yes. Some say no and
> come to pick it up the way it arrived.
>
> We write down what the bike is — a Trek Marlin, a Giant Escape — and the serial number, because two
> blue Marlins in the same week is not a joke, it happened in March and we handed the wrong one back.
>
> There are three of us in the workshop and my daughter runs the counter. Each mechanic keeps their
> own notes in their own notebook, so when a customer calls to ask if their bike is ready, whoever
> picks up the phone has to walk to the back and find out. I would like that on a screen.
>
> We charge by the job, not by the hour. There is a list on the wall — tune-up, wheel true, brake
> bleed, chain replacement, about twenty more — and each one has a price. A bike usually needs two or
> three of them. Sometimes we charge less than the list says, because it is a regular or because the
> job turned out easier than we thought. And the list goes up every January. Last year's invoices
> cannot change in January because the list changed.
>
> Half our customers come back. When they do, I want to see what we did to that bike the last time.
> Not to the customer — to the bike. People own more than one, and people sell them, and the second
> owner deserves to know the fork was replaced.
>
> We take photos when the bike arrives so that nobody argues later about who made the scratch. And
> when a mechanic works out what is wrong, they should be able to write it down properly — a
> paragraph, a list, something a person can read, not four words on a tag.
>
> One more thing. When we take a bike in we promise a day. If I said Thursday and it is Friday
> afternoon, I want to see that on the screen before the customer calls me and tells me.
>
> The wall list should be on the website too, so people stop phoning to ask what a tune-up costs.
> Nothing else public. I do not want people reading other people's repairs.

Everything you deliver must be derived from that description.

## What you are building

Four documents:

1. **User stories** — what the system does, for whom, and why.
2. **A domain model** — the entities, their attributes and their relationships, drawn in
   dbdiagram.io.
3. **A decisions record** — the calls you made where the description does not decide for you.
4. **Wireframes** — the screens, in low fidelity, and the paths between them.

## The deliverable

Create a **new public repository** named `webtech-wheelhouse`. This is the repository you will work
in for the rest of the semester: Lab 4 creates the Rails application inside it, and every lab after
that adds to it. Do not put this in your Lab 1 repository.

| File | What it is |
|---|---|
| `README.md` | What Wheelhouse is, who uses it, and links to the documents below |
| `docs/user-stories.md` | Requirement 1 and 2 |
| `docs/domain-model.md` and its image | Requirement 3, 4 and 5 |
| `docs/decisions.md` | Requirement 6 |
| `docs/wireframes.md` and its images | Requirement 7 |

**Canvas.** Submit the URL of your repository.

This lab is **individual**. One submission per student.

---

## Requirements

### 1. User stories

At least **twelve** stories, in the format from Class 3, each with its `so that`.

- Every role you found in the description appears in at least one story, and the roles that do the
  day-to-day work of the shop have at least **three** each.
- The stories cover the whole life of a repair, from the bike arriving to the bike leaving.
- **One story is deliberately too big, and you split it.** Keep the big one in the document, marked,
  followed by the two or three it becomes. The split is by value, not by layer: each piece has to be
  something a person can use on its own.
- No story may describe its own implementation, be a task rather than a need, or omit its actor.

### 2. Acceptance criteria

Four of your stories carry acceptance criteria — at least three each, written as statements that are
either true or false when you look at the finished screen.

At least one of those stories has a criterion for the case where there is nothing to show. That case
is the one most often left unspecified, and an empty region with no explanation is a defect.

### 3. The domain model

The relational diagram is built in **dbdiagram.io**. It goes in `docs/domain-model.md`: the diagram
exported as an image, and below it the code that produced it, in a fenced code block.

- The code **compiles as it is** in dbdiagram.io. Every table your `ref` lines mention is declared
  in it, and it is the code that produced the image above it.
- Every column has a type. Primary keys and foreign keys are marked.
- Every relationship is drawn, and its cardinality is the one the description implies — read it in
  both directions before you commit to it.
- One name per concept. The same thing must not be a repair in one table and a job in another.

In `docs/domain-model.md`, after the diagram and the code, document the **lifecycle**: the states a
repair goes through, and which transitions are allowed. Include the transitions that are *not*
allowed and say so.

### 4. Every entity traces back to a story

A table in `docs/domain-model.md`, one row per entity, giving the story that requires it. An entity
that cannot name its story does not go in the diagram.

### 5. Two decisions you have to defend

Also in `docs/domain-model.md`, one short paragraph each:

- **The thing and the copy of the thing.** Explain how your model prevents the mix-up the owner
  describes in March, and what a single table with a quantity column would fail to answer.
- **Derived, or stored?** Name one value the shop cares about that your schema deliberately does
  **not** have a column for, and say how it is obtained instead. Then name one value that looks
  derivable but that you stored anyway, and say what would go wrong if you had not.

### 6. The questions the description does not answer

`docs/decisions.md`. Three questions you would ask the owner if the owner were in the room, chosen
because the answer changes the model. For each one: the question, the assumption you made in order to
keep working, and what in your model would change if the answer is the other one.

### 7. Wireframes

At least **four** screens, hand-drawn on paper and photographed, or drawn in a tool as grey boxes.
Low fidelity is a requirement. Colour, typography and finish are not evaluated.

- Each screen names **which role is looking at it**. Two roles seeing the same screen differently is
  two sketches, not one.
- One of the four is the screen used at the counter to answer the question the owner describes: is
  this bike ready.
- A **navigation graph**: the screens as nodes, the ways to get from one to another as arrows. Every
  screen can be reached, and no screen is a dead end.

### 8. What you may not do

- **No Rails, no code, no `schema.rb`, no migrations.** That starts in Lab 4, from what you write
  today.
- **No entity that the description does not justify.**
- Do not resolve an ambiguity by silently inventing a rule. Ambiguity goes in requirement 6.

---

## Documentation

- [dbdiagram.io](https://dbdiagram.io) — the editor, and its **Export** menu for the image
- [DBML](https://dbml.dbdiagram.io/docs/) — the reference for the syntax dbdiagram.io reads
- Mike Cohn — [User Stories](https://www.mountaingoatsoftware.com/agile/user-stories) and
  [INVEST](https://www.agilealliance.org/glossary/invest/)
- [Wireframing](https://www.nngroup.com/articles/wireflows/) — Nielsen Norman Group on wireflows

## Deadline

**Tuesday, August 25, 20:00**, on Canvas.
