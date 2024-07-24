<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="../public/lib/chart/chart.min.js"></script>
<script src="../public/lib/easing/easing.min.js"></script>
<script src="../public/lib/waypoints/waypoints.min.js"></script>
<script src="../public/lib/owlcarousel/owl.carousel.min.js"></script>
<script src="../public/lib/tempusdominus/js/moment.min.js"></script>
<script src="../public/lib/tempusdominus/js/moment-timezone.min.js"></script>
<script src="../public/lib/tempusdominus/js/tempusdominus-bootstrap-4.min.js"></script>

<script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
<script src="//cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<!-- Template Javascript -->
<script src="../public/js/main.js"></script>
<script src="../public/js/select2.js"></script>
<!-- DataTables 
<script src="https://cdn.datatables.net/v/dt/dt-1.13.4/datatables.min.js"></script>
-->

<script src="https://cdn.datatables.net/1.11.3/js/jquery.dataTables.min.js"></script>

<!-- Botones de DataTables -->
<script src="https://cdn.datatables.net/buttons/2.2.2/js/dataTables.buttons.min.js"></script>

<!-- JSZip (necesario para los botones Excel) -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script>

<!-- Botones HTML5 de DataTables (Copy, Excel, CSV) -->
<script src="https://cdn.datatables.net/buttons/2.2.2/js/buttons.html5.min.js"></script>

<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.3.2/html2canvas.min.js"></script>


<script src="../public/lib/cryptojs/crypto-js.min.js"></script>
<script>
    window.dtoCambioCuenta = "1234567";
    $(document).ready(() => {
        var target = '';
        var path = window.location.pathname.split("/").pop();
        // Account for home page with empty path
        const myArray = path.split(".");
        let word = myArray[0];
        if (path == '') {
            target = $('nav div a[href="../Dashboard/"]');
        } else {
            target = $('nav div a[href="../' + word + '/' + path + '"]');
        }
        target.addClass('active');
    });
</script>