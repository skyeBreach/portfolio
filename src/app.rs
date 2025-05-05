pub mod components;
pub mod pages;

use components::layout::Layout;
use pages::{
    error::NotFound,
    home::Home,
};

use leptos::prelude::*;
use leptos_meta::{provide_meta_context, Stylesheet, Title};
use leptos_router::{
    components::{Route, Router, Routes},
    StaticSegment,
};

// TODO: Switch over to using the tailwind.config.js file

#[component]
pub fn App() -> impl IntoView {
    provide_meta_context();

    view! {
        <Stylesheet id="leptos" href="/pkg/portfolio.css"/>
        <Title text="Portfolio Stub"/>
        <Router>
            <Layout>
                <Routes fallback=move || view! { <NotFound /> }>
                    <Route path=StaticSegment("") view=Home />
                </Routes>
            </Layout>
        </Router>
    }
}

