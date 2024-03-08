<!doctype html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head>
    <title>Agama SuperGluu</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="icon" href="${webCtx.contextPath}/servlet/favicon" type="image/x-icon">
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            darkMode: 'class'
        }
    </script>
</head>
<body>
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
                <div class="flex items-center justify-center">
                    <img src="sg.jpg" alt="supergluu-icon" width="70" height="70">
                </div>

                <h1 class="text-xl text-center font-medium text-gray-900 md:text-2xl dark:text-white">
                    Add a new Super Gluu Device
                </h1>

                <p class="text-gray-900 font-medium leading-tight">
                    To proceed ensure you have Super Gluu in your smartphone
                </p>

                <div class="grid grid-cols-2 gap-x-2">
                    <a href="https://play.google.com/store/apps/details?id=gluu.org.super.gluu&amp;hl=en"
                       target="_blank" class="grid justify-items-center">
                        <img src="playstore.png" alt="PlayStoreIcon">
                    </a>
                    <a href="https://apps.apple.com/us/app/super-gluu/id1093479646" target="_blank"
                       class="grid justify-items-center">
                        <img src="appstore.png" alt="AppStoreIcon">
                    </a>
                </div>

                <p class="grid justify-items-center">
                    When you are done, please open the application and scan the QR code that will appear in the next
                    screen.
                </p>

                <div class="space-y-2">
                    <button type="submit"
                            name="continueBtn"
                            class="w-full text-white bg-green-600 hover:bg-green-700 font-medium rounded-lg text-sm px-5 py-2.5 text-center dark:bg-primary-600 dark:hover:bg-primary-700 dark:focus:ring-primary-800">
                        Continue
                    </button>

                    <button type="submit"
                            name="cancelBtn"
                            class="w-full text-black bg-gray-50 border border-gray-300 hover:bg-gray-100 font-medium rounded-lg text-sm px-5 py-2.5 text-center dark:bg-primary-600 dark:hover:bg-primary-700 dark:focus:ring-primary-800">
                        Cancel
                    </button>
                </div>
            </form>
        </div>
    </div>
</section>
</body>
</html>
