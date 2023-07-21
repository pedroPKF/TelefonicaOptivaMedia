({
    /**
 * Function to handle maximizing the chat.Function to start a chat request (by accessing the chat API component)
 *
 * @param cmp - The component for this state
 * @param eventName - The name of the event fired.
 * @param eventData - The data associated with the event fired.
 */
    minimizedEventHandler: function(cmp, eventName, eventData) {
        switch(eventName) {
            case "prechatState":
                cmp.set("v.message", "Chat with an Expert!");
                Break;
            default:
                cmp.set("v.message", eventData.label);
        }
    },
});