<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="utf-8">
    <link rel="shortcut icon" type="image/x-icon" href="favicon.ico">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>eMensa - @yield('pageTitle')</title>
    <meta name="description" content="Startseite der eMensa">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.4.1/css/all.css"
          integrity="sha384-5sAR7xN1Nv6T6+dT2mhtzEpVJvfS3NScPQTrOxhwjIuvcA67KV2R5Jz6kr4abQsz"
          crossorigin="anonymous">
</head>

    <body>
    <div class="container">
{{--    Navbar...--}}
        <?php $page = basename($_SERVER['PHP_SELF']); ?>
        <header class="row">
            <div class="col-3">
                <h1>e-Mensa</h1>
            </div>
            <nav class="col-6">
                <ul class="nav">
                    <li class="nav-item"><a class="nav-link <?php if ($page == 'Start.php')  echo " disabled" ?> " href="Start.php">Start</a></li>
                    <li class="nav-item"><a class="nav-link <?php if ($page == 'Produkte.php')  echo " disabled" ?> " href="Produkte.php">Mahlzeiten</a></li>
                    <li class="nav-item"><a class="nav-link active" href="#">Bestellung</a></li>
                    <li class="nav-item"><a class="nav-link active" target="_blank" href="https://www.fh-aachen.de/">FH-Aachen</a></li>
                </ul>
            </nav>
            <div class="col-3">
                <form action="http://www.google.de/search" class="row" method="get" target="_blank" id="search" title="Suche in fh-aachen.de">
                    <input id="suchbegriff" type="text" name="q" class="form-control" placeholder="Suchen.." onfocus="this.placeholder = ''" onblur="this.placeholder = 'Suchen..'" autocomplete="off"/>
                    <input type="hidden" name="as_sitesearch" value="https://www.fh-aachen.de/"/>
                    <button class="searchbutton" type="submit"><i class="fas fa-search"></i></button>
                </form>
            </div>
        </header>



        <main>
        @yield('content')
        </main>




    {{--    Footer--}}
            <footer class="row">
                <div class="col-3 copyright">
                    <i class="far fa-copyright"></i>
                    DBWT
                    <?php
                    echo date("d.m.Y", time())
                    ?>
                </div>
                <nav class="col-6">
                    <ul class="nav" id="bottom_nav">
                        <!-- die Deko-Striche evtl schöner -->
                        <li class="nav-item"><a class="nav-link" href="#">Login</a></li>
                        <li class="nav-item"><a class="nav-link" href="#">Registrieren</a></li>
                        <li class="nav-item"><a class="nav-link active" href="Zutaten.php">Zutatenliste</a></li>
                        <li class="nav-item"><a class="nav-link active" href="Impressum.php">Impressum</a></li>
                    </ul>
                </nav>
            </footer>
    <?php
    include 'inc/js.html'
    ?>
    </div>
    </body>
    </html>