# Automated Email on Chats with Bad Ratings

Zendesk Chat does not offer an easy, native method to view low-rated chat transcripts inside Zendesk Explore. This Power Automate flow fetches tickets flagged with bad ratings and exports them into a CSV file for analytical review.

> [!NOTE]
> This step-by-step documentation is currently a placeholder. A detailed walkthrough will be added soon.

---

## JSON Schemas

This flow utilizes several schema objects inside the workflow to parse Zendesk API responses:
*   [parse-bad-chat-ids-array.json](schemas/parse-bad-chat-ids-array.json)
*   [parse-each-chat.json](schemas/parse-each-chat.json)
*   [parse-page-1-and-others.json](schemas/parse-page-1-and-others.json)

---

## Full Power Automate Workflow

Below is the complete high-level configuration diagram of this flow.

![Full Flow](images/FullFlow.png)
