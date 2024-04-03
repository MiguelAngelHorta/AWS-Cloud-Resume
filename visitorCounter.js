// JS code
const counter = document.querySelector(".counter-number");
async function updateCounter() {
    let response = await fetch("https://kslf746k53gydvqvv4xhhgwbku0tjdqx.lambda-url.us-east-1.on.aws/");
    let data = await response.json();
    counter.innerHTML = ` Views: ${data}`;
}

updateCounter();