<!doctype html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head>
    <title>Agama SuperGluu</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="icon" href="${webCtx.contextPath}/servlet/favicon" type="image/x-icon">
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.4/jquery.min.js"
            integrity="sha512-pumBsjNRGGqkPzKHndZMaAG+bir374sORyzM3uulLV14lN5LyykqNk8eEeUlUkB3U0M4FApyaHraT65ihJhDpQ=="
            crossorigin="anonymous" referrerpolicy="no-referrer"></script>
    <script src="${webCtx.contextPath}/js/jquery-qrcode-0.17.0.min.js"></script>
    <script src="${webCtx.contextPath}/js/gluu-auth.js"></script>
    <script>
        tailwind.config = {
            darkMode: 'class'
        }
    </script>
</head>
<body>
<script>
    function startCounter(seconds) {
        const counterElement = document.getElementById("counter");
        counterElement.textContent = seconds;
        const progressBarElement = document.getElementById("progressCounter");
        // Calculate the increment of the progress bar per iteration
        const toIncrement = 100 / seconds;
        const interval = setInterval(function () {
            seconds--;
            // Calculate the percentage of progress
            const percentageAdvance = parseFloat(progressBarElement.style.width) + toIncrement;
            progressBarElement.style.width = percentageAdvance + "%";
            // Display the new counter value
            counterElement.textContent = seconds;
            if (seconds <= 0) {
                clearInterval(interval);
                counterElement.textContent = "¡Tiempo terminado!";
                progressBarElement.style.width = "100%";
            }
        }, 1000); // 1000 millisecond interval (1 second)
    }

    function renderQR(qrText) {
        const options = {
            render: 'canvas',
            minVersion: 1,
            maxVersion: 40,
            ecLevel: 'L',
            left: 0,
            top: 0,
            size: 260,
            fill: '#000',
            background: null,
            text: qrText,
            radius: 0,
            quiet: 0,
            mode: 0,
            mSize: 0.1,
            mPosX: 0.5,
            mPosY: 0.5,
            label: null,
            fontname: 'sans',
            fontcolor: '#000',
            image: null
        }
        $("#qrCodeContainer").html("")
        $("#qrCodeContainer").qrcode(options)
    }

    function onSignInCallback(result) {
        console.info("Result: " + result)
        if (result === "success") {
            document.forms[0].submit();
            console.info('Success OK');
        } else {
            if (result === "error") {
                /*setError("An error has occurred")*/
                console.error('Error controlado');
            }
            timeLeft = 1
            /*$("#timer").html("")*/
        }
    }

    window.addEventListener("load", (event) => {
        renderQR('${request?no_esc}');
        startCounter(${timeout});
        gluu_auth.startSessionChecker(onSignInCallback, ${timeout});
    });
</script>
<section class="bg-gray-100 dark:bg-gray-900">
    <div class="flex flex-col items-center justify-center px-6 py-8 mx-auto md:h-screen lg:py-0">
        <div class="flex flex-col items-center mb-6 text-2xl font-semibold text-gray-900 dark:text-white">
            <img class="w-40 mr-2"
                 src="https://gluu.org/wp-content/uploads/2021/02/janssen-project-transparent-630px-182px-300x86.png"
                 alt="logo">
        </div>
        <div class="w-full bg-white rounded-lg shadow-lg dark:border md:mt-0 sm:max-w-md xl:p-0 dark:bg-gray-800 dark:border-gray-700">
            <form method="post" enctype="application/x-www-form-urlencoded"
                  class="p-6 space-y-4 md:space-y-6 sm:p-8">

                <h1 class="text-xl text-center font-medium text-gray-900 md:text-xl dark:text-white">
                    Scan the QR code with Super Gluu App (Android or iOS)
                </h1>

                <div id="qrCodeContainer" class="grid grid-cols-1 justify-items-center">
                </div>

                <div  class="w-full bg-gray-200 rounded-full h-2.5 dark:bg-gray-700">
                    <div id="progressCounter" class="bg-blue-600 h-2.5 rounded-full" style="width: 0"></div>
                </div>

                <p class="flex justify-center gap-x-1">
                    Time Remaining: <span><span id="counter"></span> secs</span>
                </p>

                <input type="hidden" id="tokenResponse" nddame="tokenResponse">
                <input type="hidden" id="skipped" name="skipped">
                <input type="hidden" id="errorMessage" name="errorMessage">
            </form>
        </div>
    </div>
</section>
</body>
</html>
