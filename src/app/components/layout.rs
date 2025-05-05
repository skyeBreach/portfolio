use leptos::prelude::*;

///
#[component]
pub fn Layout(children: Children) -> impl IntoView {
    view! {
        <div class="h-screen bg-gray-700">
            <main class="text-white">
                {children()}
            </main>
        </div>
    }
}
