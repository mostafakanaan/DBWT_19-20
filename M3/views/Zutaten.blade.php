@extends('app')
@section('pageTitle','Zutaten')

@section('content')

    <h3><?php echo 'Zutaten ' .'('.$count.')' ?></h3>
    <table class="table table-striped">
        <!--    Tabellen Kopf -->
        <thead class="thead-dark">
        <tr>
            <th>Zutat</th>
            <th class="table-element">Vegan?</th>
            <th class="table-element">Vegetarisch?</th>
            <th class="table-element">Glutenfrei?</th>
        </tr>
        </thead>
        <tbody>
        <!--  Zutaten Row  -->
        <?php if ($result) { // Query ausführen..
            while ($row = mysqli_fetch_assoc($result)) {
                $name = $row['Name'];
                echo '<tr> <td> <a href="https://www.google.com/search?q=' .$name .'" target="_blank"',
                    ' title="Suchen Sie nach ' . $name . ' im Web">' , $name,
                ($row['Bio']? '<img src="img/bio.png"  title="Bio" alt="Bioabzeichen"/>' : ''),
                '</a> </td> <td class="table-element">',
                ($row['Vegan']? '<i class="far fa-check-circle fa-2x"></i>' : '<i class="far fa-times-circle fa-2x"></i>'),
                '</td> <td class="table-element">',
                ($row['Vegetarisch']? '<i class="far fa-check-circle fa-2x"></i>' : '<i class="far fa-times-circle fa-2x"></i>'),
                '</td> <td class="table-element">',
                ($row['Glutenfrei']? '<i class="far fa-check-circle fa-2x"></i>' : '<i class="far fa-times-circle fa-2x"></i>'),
                '</td> </tr>';
            }
        }
        ?>
        </tbody>
    </table>
@endsection