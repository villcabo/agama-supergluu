<!doctype html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head>
    <title>Agama SuperGluu</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="icon" href="${webCtx.contextPath}/servlet/favicon" type="image/x-icon">
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.4/jquery.min.js"
            integrity="sha512-pumBsjNRGGqkPzKHndZMaAG+bir374sORyzM3uulLV14lN5LyykqNk8eEeUlUkB3U0M4FApyaHraT65ihJhDpQ=="
            crossorigin="anonymous" referrerpolicy="no-referrer">
    </script>
    <script src="${webCtx.contextPath}/js/gluu-auth.js"></script>
    <script>
        tailwind.config = {
            darkMode: 'class'
        }
    </script>
</head>
<body>
<script>
    function setError(msg) {
        document.getElementById("alert-message").show();
        document.getElementById("alert-error").textContent = msg;
    }

    function onSignInCallback(result) {
        console.log("Result: " + result);
        if (result === "success") {
            document.forms[0].submit();
        } else {
            let msg = "An error occurred";
            if (result === "timeout") {
                msg = "We couldn't detect approval of the notification sent";
            }
            setError(msg);
        }
    }

    window.onload = (event) => {
        gluu_auth.startSessionChecker(onSignInCallback, ${timeout});
    }
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

                <h1 class="text-lg text-center font-medium text-gray-900 md:text-xl dark:text-white">
                    You will get a notification to your Super Gluu shortly
                </h1>

                <div class="flex items-center justify-center">
                    <img src="sg.jpg" alt="supergluu-icon" class="w-24 h-24">
                </div>

                <p class="text-gray-600 leading-tight">
                    You will be authenticated once you tap <b>&quot;approve&quot;</b> in the notification screen.
                </p>

                <div class="w-full border-t border-gray-300"></div>

                <div id="alert-message" hidden
                     class="p-4 mb-4 text-red-800 border border-red-300 rounded-lg bg-red-50 dark:bg-gray-800 dark:text-red-400 dark:border-red-800"
                     role="alert">
                    <div class="flex items-center">
                        <svg aria-hidden="true" height="16" viewBox="0 0 16 16" version="1.1" width="16"
                             data-view-component="true" class="flex-shrink-0 w-4 h-4 me-2 fill-red-700">
                            <path d="M6.457 1.047c.659-1.234 2.427-1.234 3.086 0l6.082 11.378A1.75 1.75 0 0 1 14.082 15H1.918a1.75 1.75 0 0 1-1.543-2.575Zm1.763.707a.25.25 0 0 0-.44 0L1.698 13.132a.25.25 0 0 0 .22.368h12.164a.25.25 0 0 0 .22-.368Zm.53 3.996v2.5a.75.75 0 0 1-1.5 0v-2.5a.75.75 0 0 1 1.5 0ZM9 11a1 1 0 1 1-2 0 1 1 0 0 1 2 0Z"></path>
                        </svg>
                        <span class="sr-only">Info</span>
                        <h3 class="text-lg font-medium">Authentication Error</h3>
                        <button type="button"
                                onclick="document.getElementById('alert-message').style.display = 'none'"
                                class="ms-auto -mx-1.5 -my-1.5 bg-red-50 text-red-500 rounded-lg focus:ring-2 focus:ring-red-400 p-1.5 hover:bg-red-200 inline-flex items-center justify-center h-8 w-8 dark:bg-gray-800 dark:text-red-400 dark:hover:bg-gray-700"
                                data-dismiss-target="#alert-border-2" aria-label="Close">
                            <span class="sr-only">Dismiss</span>
                            <svg class="w-3 h-3" aria-hidden="true" xmlns="http://www.w3.org/2000/svg"
                                 fill="none"
                                 viewBox="0 0 14 14">
                                <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round"
                                      stroke-width="2" d="m1 1 6 6m0 0 6 6M7 7l6-6M7 7l-6 6"/>
                            </svg>
                        </button>
                    </div>
                    <div class="mt-2 mb-4 text-sm" id="alert-error">
                    </div>
                </div>

                <p class="text-gray-800 leading-tight">
                    Didn't receive a notification?
                </p>

                <button type="submit" name="continue"
                        class="w-full text-white bg-green-600 hover:bg-green-700 font-medium rounded-lg text-sm px-5 py-2.5 text-center dark:bg-primary-600 dark:hover:bg-primary-700 dark:focus:ring-primary-800">
                    Scan a QR code instead
                </button>
            </form>
        </div>
    </div>
</section>
</body>
</html>
