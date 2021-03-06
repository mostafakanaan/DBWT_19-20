@extends('app')
@section('pageTitle','Detail')
@section('content')
    <div class="row background" id="detailsTitel">

        <h2 class="align-text-center" id="details">Details für <?php  echo '"' . $arrayofrows[0][4] . '"' ?></h2>
        <!--                Mahlid = id in der url als Getparamter in [4] ist der name der Mahlzeit gespeichert...-->
    </div>

    <div class="row">
        <div class="col-2" id="logincol">
            <div class="card background" id="login">
                <div class="card-body align-text-center">
                    <h5 class="card-title align-text-center"><i class="fas fa-sign-in-alt"></i> Login</h5>

                    <form action="Auth.php" method="POST">
                        <div class="form-group">

                            @if ($_SESSION['error'] == true)
                                @php $_SESSION['error'] = false @endphp
                                <p class="alert alert-danger">Das hat nicht geklappt! Bitte versuchen sie es
                                    erneut..</p>
                                <input type="text" class="form-control alert alert-danger" id="email" name="benutzer"
                                       placeholder="Benutzer">
                                <br>
                                <input type="password" class="form-control alert alert-danger" id="password"
                                       name="password"
                                       placeholder="*******">
                                <br>
                                <input type="submit" class="btn btn-primary button" value="Anmelden">

                            @elseif (!isset($_SESSION['user']))
                                <label for="email">Benutzer</label>
                                <input type="text" name="benutzer" class="form-control" id="email"
                                       placeholder="Benutzer-ID.."
                                       onfocus="this.placeholder = ''" onblur="this.placeholder = 'Benutzer-ID..'"
                                       autocomplete="off">
                                <label for="password">Passwort</label>
                                <input type="password" name="password" class="form-control" id="password"
                                       placeholder="Aktuelles Passwort.."
                                       onfocus="this.placeholder = ''"
                                       onblur="this.placeholder = 'Aktuelles Passwort..'"
                                       autocomplete="off">

                                <input type="submit" name="action" class="btn btn-dark align-text-center"
                                       value="Anmelden">
                            @else
                                <div class="row">
                                    Hallo {{$_SESSION['user']}}, Sie sind angemeldet als {{$_SESSION['role']}}.
                                </div>
                                <br>
                                <div class="row justify-content-center">
                                    <input type="submit" class="btn btn-primary button" name="action" value="Abmelden">
                                </div>
                            @endif
                            <input type="hidden" name="id" value="{{$arrayofrows[0][0]}}">
                        </div>
                    </form>
                </div>
            </div>
            @if (!isset($_SESSION['user']))
                <p id="register">Melden Sie sich jetzt an, um die wirklich viel günstigeren Preise für Mitarbeiter oder
                    Studenten zu sehen.
                </p>
            @endif
        </div>
        <div class="col-6" id="produktcol">

            <img src="data:image/gif;base64,<?php echo base64_encode($arrayofrows[0][10]) ?>" id="produktimg"
                 alt=" <?php  echo $arrayofrows[0][8] ?>"/>

            <!-- Nav tabs -->
            <ul class="nav nav-tabs" id="myTab" role="tablist">
                <li class="nav-item">
                    <a class="nav-link active" id="home-tab" data-toggle="tab" href="#beschreibung" role="tab"
                       aria-controls="beschreibung" aria-selected="true">Beschreibung</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" id="zutaten-tab" data-toggle="tab" href="#zutaten" role="tab"
                       aria-controls="zutaten" aria-selected="false">Zutaten</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" id="bewertungen-tab" data-toggle="tab" href="#bewertungen" role="tab"
                       aria-controls="bewertungen" aria-selected="false">Bewertungen</a>
                </li>
            </ul>
            <!-- Tab panes -->
            <div class="tab-content">
                <div class="tab-pane active" id="beschreibung" role="tabpanel"><?php echo $arrayofrows[0][5]?>
                </div>
                <div class="tab-pane" id="zutaten" role="tabpanel" aria-labelledby="zutaten-tab">
                    <!--                            Zutaten ausgabe..-->
                    <?php
                    foreach ($arrayofrowszutat as $zutat) {// Alle Zutaten im Array ausgeben...
                        if ($zutat == end($arrayofrowszutat)) {//Wenn das die letzte Zutat im Array ist...
                            echo $zutat[2];

                        } else {//Wenns nicht die letzte ist...
                            echo $zutat[2] . ', ';
                        }

                    }
                    ?>
                </div>
                <div class="tab-pane" id="bewertungen" role="tabpanel">
                    <form action="http://bc5.m2c-lab.fh-aachen.de/form.php" method="post" id="bewertungsform">
                        <input type="hidden" name="matrikel" value="3167397"/>
                        <input type="hidden" name="kontrolle" value="KAN"/>
                        <div class="form-group" id="benutzername">
                            <div class="row">
                                <label for="name"><b>Benutzername:</b></label>
                                <input id="name" class="form-control" name="benutzer" placeholder="zB: remmy.."
                                       onfocus="this.placeholder = ''" onblur="this.placeholder = 'zB: remmy..'"
                                       autocomplete="off">
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-4">
                                <div class="form-group mahlzeiten">
                                    <select class="form-control mahlzeiten" name="mahlzeit">
                                        <option disabled selected class="align-text-center">Mahlzeit</option>
                                        <option>Curry Wok</option>
                                        <option>Schnitzel</option>
                                        <option>Bratrolle</option>
                                        <option>Krautsalat</option>
                                        <option>Falafel</option>
                                        <option>Currywurst</option>
                                        <option>Käsestulle</option>
                                        <option>Spiegelei</option>
                                    </select>
                                </div>
                            </div>
                            <div class="col-4">
                                <div class="form-group">
                                    <select class="form-control bewertung" name="bewertung">
                                        <option disabled selected class="align-text-center">Bewertung</option>
                                        <option>1</option>
                                        <option>2</option>
                                        <option>3</option>
                                        <option>4</option>
                                        <option>5</option>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-5">
                                <label for="bemerkung" class="visuallyhidden"></label>
                                <textarea class="form-control" id="bemerkung" name="bemerkung"
                                          placeholder="Wie hat's Ihnen geschmeckt?"></textarea>
                            </div>
                            <div class="col-3">
                                <button type="submit" id="sendbtn" class="btn btn-primary"><i
                                            class="far fa-check-circle"></i> Senden
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <div class="col-2 align-text-center" id="preiscol">
            <p id="spreis">
                <?php
                if ($_SESSION['role'] == 'Student')
                    echo "<b>Studenten-</b>";
                elseif ($_SESSION['role'] == 'Mitarbeiter')
                    echo "<b>MA-</b>";
                else echo "<b>Gast-</b>";
                ?>
                Preis :</p>
            <p id="preis">
                <?php
                if ($_SESSION['role'] == 'Student')
                    echo $arrayofrows[0][3];
                elseif ($_SESSION['role'] == 'Mitarbeiter')
                    echo $arrayofrows[0][2];
                else echo $arrayofrows[0][1];
                ?>
            </p>
            <button type="button" class="btn btn-primary btn-lg"><i class="fas fa-utensils"></i> Vorbestellen
            </button>
        </div>
    </div>
@endsection