/**
 * Visitor counter — fetches view count from Lambda function URL
 * and updates all elements with the .visitor-count class.
 */
(function () {
    const API_URL =
        "https://kslf746k53gydvqvv4xhhgwbku0tjdqx.lambda-url.us-east-1.on.aws/";

    async function updateCounter() {
        const counters = document.querySelectorAll(".visitor-count");
        if (!counters.length) return;

        try {
            const response = await fetch(API_URL);
            if (!response.ok) throw new Error(`HTTP ${response.status}`);

            const data = await response.json();
            counters.forEach((el) => {
                el.textContent = `Views: ${data}`;
            });
        } catch (error) {
            console.error("Visitor counter failed:", error);
            // Silently degrade — don't show broken UI
            counters.forEach((el) => {
                el.textContent = "";
            });
        }
    }

    if (document.readyState === "loading") {
        document.addEventListener("DOMContentLoaded", updateCounter);
    } else {
        updateCounter();
    }
})();
