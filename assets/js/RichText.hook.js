import EasyMDE from "easymde";

const init = (element) => new EasyMDE({
    element: element,
    forceSync: true
})

export const RichText = {
    mounted() {
        init(this.el.querySelector("#song_notes_input"))
    },
    updated() {
        const textArea = init(this.el.querySelector("#song_notes_input"));
        textArea.codemirror.on("change", () => {
            this.pushEventTo(
                this.el,
                "handle_clientside_richtext",
                { richtext_data: textArea.value() }
            );
            this.handleEvent(
                "richtext_event",
                (richtext_data) => textArea.value(richtext_data)
            )
        })
    }
}