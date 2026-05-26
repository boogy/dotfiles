import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { Type } from "typebox";

export default function (pi: ExtensionAPI) {
  console.log("✓ Extension factory function called");

  // Test 1: Session event handling
  pi.on("session_start", async (event, ctx) => {
    console.log(`✓ session_start event fired (reason: ${event.reason})`);
    ctx.ui.notify("Test extension loaded!", "info");
  });

  // Test 2: Custom tool registration
  pi.registerTool({
    name: "test_greet",
    label: "Test Greet",
    description: "A test tool that greets someone by name",
    parameters: Type.Object({
      name: Type.String({ description: "Name to greet" }),
      enthusiasm: Type.Optional(
        Type.Number({ description: "Enthusiasm level (1-10)", minimum: 1, maximum: 10 })
      ),
    }),
    async execute(toolCallId, params, signal, onUpdate, ctx) {
      console.log(`✓ test_greet tool executed with params:`, params);
      
      const exclamation = "!".repeat(params.enthusiasm || 1);
      const greeting = `Hello, ${params.name}${exclamation}`;
      
      return {
        content: [{ type: "text", text: greeting }],
        details: { greetedName: params.name, enthusiasm: params.enthusiasm || 1 },
      };
    },
  });

  // Test 3: Custom command registration
  pi.registerCommand("test-status", {
    description: "Show test extension status",
    handler: async (args, ctx) => {
      console.log("✓ test-status command executed");
      const entries = ctx.sessionManager.getEntries();
      const message = `Test extension active. Session has ${entries.length} entries.`;
      ctx.ui.notify(message, "success");
    },
  });

  // Test 4: Tool call interception
  pi.on("tool_call", async (event, ctx) => {
    console.log(`✓ tool_call event: ${event.toolName}`);
    
    if (event.toolName === "test_greet") {
      console.log("  → Intercepted test_greet call");
    }
  });

  // Test 5: Agent lifecycle events
  pi.on("agent_start", async (event, ctx) => {
    console.log("✓ agent_start event fired");
  });

  pi.on("agent_end", async (event, ctx) => {
    console.log("✓ agent_end event fired");
    console.log(`  → Processed ${event.messages.length} messages`);
  });

  // Test 6: Keyboard shortcut
  pi.registerShortcut("ctrl+shift+t", {
    description: "Test extension shortcut",
    handler: async (ctx) => {
      console.log("✓ Keyboard shortcut triggered");
      ctx.ui.notify("Test shortcut activated! (Ctrl+Shift+T)", "info");
    },
  });

  console.log("✓ Extension initialization complete");
  console.log("  → Registered tool: test_greet");
  console.log("  → Registered command: /test-status");
  console.log("  → Registered shortcut: Ctrl+Shift+T");
  console.log("  → Subscribed to events: session_start, tool_call, agent_start, agent_end");
}
