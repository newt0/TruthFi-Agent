**⚠️ Please note:**

This SDK documentation is provided for early access and learning purposes only. The official SDK and complete documentation will be released when the hackathon officially begins.

###

Overview

`ApusAI` is a lightweight Lua library for the AO ecosystem, designed to provide a simple and elegant interface for interacting with the **APUS AI Inference Service**.

This library handles all the underlying complexities of the AO protocol, including:

- Formatting `ao.send` messages.
- Interacting with the `APUS Token Process` for payments.
- Structuring the `Data` field with your prompt and options.
- Managing asynchronous responses and error handling.

With `ApusAI`, you can integrate powerful, decentralized AI into your AO processes with just a few lines of code, without needing to know the low-level details of the service's handlers.

###

Getting Started

Interacting with the APUS AI Inference Service via this library is straightforward.

####

Installation

First, ensure you have a package manager like [APM](https://apm_betteridea.g8way.io/) available in your `aos` environment. Then, install the `ApusAI` library:

```html
-- This is a hypothetical package name APM.install("@apus/ai-lib")
```

####

Usage

Once installed, you can `require` the module and start making inference requests.

**Important:** Your process must hold a sufficient balance of `$APUS` tokens to pay for the inference requests. You can check the current price using the `ApusAI.getInfo()` function.

####

Example 1: Simple Prompt

This is the simplest way to get a response. The library will handle the asynchronous response and print the result directly to your process's console.

```html
local ApusAI = require("apus-ailib-Beta") -- Run a simple prompt. The response
will be printed to the console. print("Sending inference request...")
ApusAI.infer("What is Arwave")
```

####

Example 2: Advanced Inference with a Callback

For most applications, you'll want to handle the response programmatically. You can do this by providing a callback function. This example also demonstrates how to use advanced inference options.

```html
local ApusAI = require("@apus/ai-lib") local prompt = "Translate the following
to French: 'The future is decentralized.'" local options = { max_tokens = 50,
temp = 0.5, system_prompt = "You are a helpful translation assistant." } -- The
infer function immediately returns a task reference for tracking. local taskRef
= ApusAI.infer(prompt, options, function(err, res) if err then -- Handle any
errors that occurred during the process print("Error: " .. err.message) return
end -- Process the successful response print("Translation received: " ..
res.data) print("Session ID for follow-up: " .. res.session) -- You can now use
res.session to continue the conversation end) print("Inference task submitted.
Task Reference: " .. taskRef)
```

###

API Reference

####

`ApusAI.infer(prompt, options, callback)`

Submits an AI inference request. This function is asynchronous.

- `**prompt**` (`string`): **Required.** The text prompt to send to the AI model.
- `**options**` (`table`): **Optional.** A table of parameters to customize the inference.

  - `max_tokens` (`number`): The maximum number of tokens to generate. Defaults to `2000`.
  - `temp` (`number`): The temperature for generation (e.g., `0.7`).
  - `top_p` (`number`): The top-p sampling value (e.g., `0.5`).
  - `system_prompt` (`string`): A system message to guide the model's behavior.
  - `session` (`string`): A session ID from a previous response to continue a conversation.
  - `reference` (`string`): A custom unique ID for the request. If omitted, a unique ID is generated automatically.

- `**callback(err, res)**` (`function`): **Optional.** A function that will be called with the result. If omitted, the result is printed to the console.

  - `**err**` (`table`): An error object if the request fails, otherwise `nil`. The object has the shape `{ code = "ERROR_CODE", message = "Error details" }`.
  - `**res**` (`table`): A result object on success, otherwise `nil`. The object has the shape:

    ```html
    { data = "The AI's text response.", session =
    "The-session-id-for-this-conversation", attestation =
    "The-gpu-attestation-string", reference = "The-unique-request-reference" }
    ```

- **Returns**: `string` - A unique `taskRef` for this request, which can be used with `getTaskStatus`.

####

`ApusAI.getInfo(callback)`

Fetches the current status and pricing of the APUS AI Inference Service.

- `**callback(err, info)**` (`function`): **Required.** A function to handle the response.

  - `**err**`: An error object if the request fails, otherwise `nil`.
  - `**info**`: A table containing service information on success:

    ```html
    { price = 100, -- Price in Armstrongs worker_count = 4, pending_tasks = 10 }
    ```

####

`ApusAI.getTaskStatus(taskRef, callback)`

Retrieves the cached status of a previously submitted task.

- `**taskRef**` (`string`): **Required.** The task reference returned by the `ApusAI.infer` function.
- `**callback(err, status)**` (`function`): **Required.** A function to handle the response.

  - `**err**`: An error object if the request fails, otherwise `nil`.
  - `**status**`: A table containing the detailed task status on success. (See the [Cache API documentation](https://www.notion.so/Hackthon-API-Design-2380787b399c806a89a6ecf4787fa6fa?pvs=21) for the full structure).

###

Full Conversational Example

This example shows how to create a simple chatbot that maintains a conversation using the `session` ID.

```html
local ApusAI = require("@apus/ai-lib") -- A simple state machine for our chatbot
local state = { session = nil, -- We start with no session question = "Hello,
what is your name?" } function handleResponse(err, res) if err then
print("Chatbot Error: " .. err.message) return end print("AI: " .. res.data) --
Save the session ID for the next turn state.session = res.session -- Ask the
next question (in a real app, this would come from user input) if state.question
== "Hello, what is your name?" then state.question = "What can you do?"
runInference() elseif state.question == "What can you do?" then print("Chatbot
conversation finished.") end end function runInference() print("You: " ..
state.question) local options = { session = state.session -- Pass the current
session ID } ApusAI.infer(state.question, options, handleResponse) end -- Start
the conversation runInference()
```
