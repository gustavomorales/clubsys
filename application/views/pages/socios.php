<!DOCTYPE html>
<html lang="en">
<head>
    <title>ClubSys - Socios</title>
    <?php $this->load->view('templates/head'); ?>
</head>
<body>
    <div id="wrapper">
        <?php $this->load->view('templates/nav_admin'); ?>
        <div id="page-wrapper">
            <div class="container-fluid">
                <!-- Page Heading -->
                <div class="row">
                    <div class="col-lg-12">
                        <h1 class="page-header">
                            Socios
                            <small>Los pibes del club</small>
                        </h1>
                        <ol class="breadcrumb">
                            <li>
                                <i class="fa fa-dashboard"></i>  <?php echo anchor('dashboard', 'Dashboard');?>
                            </li>
                            <li class="active">
                                <i class="fa fa-file"></i> Usuarios
                            </li>
                        </ol>
                    </div>
                    <?php $this->load->view('templates/mensajes'); ?>
                    <div class="col-sm-6">
                        <!-- Button trigger modal -->
                        <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#socioModal">
                            <i class="glyphicon glyphicon-plus"></i> Agregar socio
                        </button>
                    </div>
                    <div class="col-sm-6 text-right">
                        <?php echo form_open('socios','class="form-inline role="search"'); ?>
                        <div class="input-group">
                            <input type="search" name="busqueda" class="form-control" placeholder="Buscar...">
                            <span class="input-group-btn">
                                <button type="submit" class="btn btn-default" name="submitBuscar">
                                    <i class="glyphicon glyphicon-search"></i>
                                </button>
                            </span>
                        </div><!-- /input-group -->
                        <?php echo form_close(); ?>
                    </div>
                    <!-- Modal -->
                    <div class="modal fade" id="socioModal" tabindex="-1" role="dialog" aria-labelledby="socioModalLabel" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                                    <h4 class="modal-title" id="socioModalLabel">Agregar socio</h4>
                                </div>
                                <?php echo form_open('socios/agregar','class="form-horizontal"'); ?>
                                <div class="modal-body">
                                    <div class="form-group">
                                        <label for="inputNombres" class="col-sm-2 control-label">Nombres</label>
                                        <div class="col-sm-10">
                                            <input type="text" class="form-control" id="inputNombres" name="nombres" placeholder="Nombres">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="inputApellidos" class="col-sm-2 control-label">Apellidos</label>
                                        <div class="col-sm-10">
                                            <input type="text" class="form-control" id="inputApellidos" name="apellidos" placeholder="Apellidos">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="inputdni" class="col-sm-2 control-label">DNI</label>
                                        <div class="col-sm-10">
                                            <input type="text" class="form-control" id="inputdni" name="dni" placeholder="DNI">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="selectTipo" class="col-sm-2 control-label">Tipo</label>
                                        <div class="col-sm-10">
                                        <select name="tipo" class="form-control">
                                            <?php foreach ($tipos as $tipo_item) {
                                                echo "<option value=\"{$tipo_item['id']}\">{$tipo_item['nombre']}</option>";
                                            }
                                            ?>
                                        </select>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="inputDireccion" class="col-sm-2 control-label">Dirección</label>
                                        <div class="col-sm-10">
                                            <input type="text" class="form-control" id="inputDireccion" name="direccion" placeholder="Dirección">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="inputFechaNacimiento" class="col-sm-2 control-label">Fecha de nacimiento</label>
                                        <div class="col-sm-10">
                                            <input type="date" class="form-control" id="inputFechaNacimiento" name="fechaNacimiento">
                                        </div>
                                    </div>
                                </div>
                                <!-- /.modal-body -->
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>
                                    <button type="submit" class="btn btn-primary">Agregar</button>
                                </div>
                                <?php echo form_close(); ?>
                            </div>
                            <!--- /.modal-content -->
                        </div>
                        <!--- /.modal-dialog -->
                    </div>
                    <!-- /.modal -->
                    <div class="table-responsive col-sm-12">
                        <?php
                        $this->table->set_heading(array('#', 'DNI', 'Apellidos y nombres', 'Tipo', 'Dirección', 'Fecha de nacimiento', 'Fecha de inscripción', ""));
                        foreach ($socios as $socios_item) {
                            $this->table->add_row(array(
                                $socios_item['usuario_id'],
                                $socios_item['dni'],
                                $socios_item['nombre_completo'],
                                $socios_item['tipo'],
                                $socios_item['direccion'],
                                $socios_item['fecha_nacimiento'],
                                $socios_item['fecha_inscripcion'],
                                anchor("actividades/lista_actividades/{$socios_item['usuario_id']}", '<i class="glyphicon glyphicon-list"></i>', array('class' => 'btn btn-info btn-sm', "role" => "button", "title" => "Lista de actividades"))." ".
                                '<button type="button" class="btn btn-info btn-sm btnModificarSocio" title="Modificar" data-toggle="modal" data-target="#modificarModal">
                                <i class="glyphicon glyphicon-pencil"></i>
                            </button>'." ".
                            anchor("socios/eliminar/{$socios_item['usuario_id']}", '<i class="glyphicon glyphicon-trash">', array('onclick'=>"return confirm('¿Está seguro que desea eliminar al socio {$socios_item['nombre_completo']}?')", 'class' => 'btn btn-danger btn-sm', "role" => "button", "title" => "Eliminar"))
                            ));
}
echo $this->table->generate();
?>
</div>
<!--- /.table-responsive -->
<div class="col-sm-12">
    <!-- Button trigger modal -->
    <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#socioModal">
        <i class="glyphicon glyphicon-plus"></i> Agregar socio
    </button>
</div>
<!-- Modal -->
<div class="modal fade" id="modificarModal" tabindex="-1" role="dialog" aria-labelledby="modificarModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="modificarModalLabel">Modificar socio</h4>
            </div>
            <?php echo form_open('socios/modificar','class="form-horizontal"'); ?>
            <div class="modal-body">
                <input type="hidden" id="inputIdMod" name="idMod" value="">
                <div class="form-group">
                    <label for="inputApellidosMod" class="col-sm-2 control-label">Apellidos</label>
                    <div class="col-sm-10">
                        <input type="text" class="form-control" id="inputApellidosMod" name="apellidosMod" placeholder="Apellidos">
                    </div>
                </div>
                <div class="form-group">
                    <label for="inputNombresMod" class="col-sm-2 control-label">Nombres</label>
                    <div class="col-sm-10">
                        <input type="text" class="form-control" id="inputNombresMod" name="nombresMod" placeholder="Nombres">
                    </div>
                </div>
                <input type="hidden" id="inputDniActual" name="dniActual" value="">
                <div class="form-group">
                    <label for="inputDniMod" class="col-sm-2 control-label">DNI</label>
                    <div class="col-sm-10">
                        <input type="text" class="form-control" id="inputDniMod" name="dniMod" placeholder="DNI">
                    </div>
                </div>
                <div class="form-group">
                    <label for="selectTipoMod" class="col-sm-2 control-label" name="tipoMod">Tipo</label>
                    <div class="col-sm-10">
                        <select class="form-control" name="tipoMod">
                            <?php foreach ($tipos as $tipo_item) {
                                echo "<option value=\"{$tipo_item['id']}\">{$tipo_item['nombre']}</option>";
                            }
                            ?>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label for="inputDireccionMod" class="col-sm-2 control-label">Dirección</label>
                    <div class="col-sm-10">
                        <input type="text" class="form-control" id="inputDireccionMod" name="direccionMod" placeholder="Dirección">
                    </div>
                </div>
                <div class="form-group">
                    <label for="inputFechaNacimientoMod" class="col-sm-2 control-label">Fecha de nacimiento</label>
                    <div class="col-sm-10">
                        <input type="date" class="form-control" id="inputFechaNacimientoMod" name="fechaNacimientoMod">
                    </div>
                </div>
            </div>
            <!-- /.modal-body -->
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>
                <button type="submit" class="btn btn-primary">Modificar</button>
            </div>
            <?php echo form_close(); ?>
        </div>
        <!--- /.modal-content -->
    </div>
    <!--- /.modal-dialog -->
</div>
<!-- /.modal -->
</div>
<!-- /.row -->
</div>
<!-- /.container-fluid -->
</div>
<!-- /#page-wrapper -->
</div>
<!-- /#wrapper -->
<?php $this->load->view('templates/footer'); ?>
<?php $this->load->view('templates/scripts'); ?>
<script>
        $(document).ready(function() {
            $(".btnModificarSocio").click(function() {
                var tableData = $(this).closest("tr").children("td").map(function() {
                    return $(this).text();
                }).get();
                $("#inputIdMod").val($.trim(tableData[0]));
                var arr = tableData[2].split(', ');
                $("#inputApellidosMod").val($.trim(arr[0]));
                $("#inputNombresMod").val($.trim(arr[1]));
                $("#inputDniActual").val($.trim(tableData[1]));
                $("#inputDniMod").val($.trim(tableData[1]));
                $("#inputIdMod").val($.trim(tableData[0]));
                $("#inputDireccionMod").val($.trim(tableData[4]));
                $("#inputFechaNacimientoMod").val($.trim(tableData[5]));
                $("#selectTipoMod option").filter(function() {
                    return($(this).text() == $.trim(tableData[3]))
                }).prop('selected', true);
            })
        }); 
    </script>
</body>
</html>