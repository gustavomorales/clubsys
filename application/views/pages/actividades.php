<!DOCTYPE html>
<html>
<head>
	<title>Actividades</title>
	<?php $this->load->view('templates/head'); ?>
</head>
<body>

	<div id="wrapper">
		<?php $this->load->view('templates/nav_admin'); ?>
		<div id="page-wrapper">

			<div class="container-fluid">
				<div class="row">
					<div class="col-lg-12">
						<h1 class="page-header">
							Actividades
							<small>del club</small>
						</h1>
						<ol class="breadcrumb">
							<li>
								<i class="fa fa-dashboard"></i>  <?php echo anchor('dashboard', 'Dashboard');?>
							</li>
							<li class="active">
								<i class="fa fa-file"></i> Actividades
							</li>
						</ol>
					</div>
					<?php $this->load->view('templates/mensajes'); ?>
					<div class="col-sm-6">
						<!-- Button trigger modal -->
						<button type="button" class="btn btn-primary" data-toggle="modal" data-target="#myModal">
							<i class="glyphicon glyphicon-plus"></i> Agregar Actividad
						</button>
					</div>
					
					<!-- Modal -->
					<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
						<div class="modal-dialog">
							<div class="modal-content">
								<div class="modal-header">
									<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
									<h4 class="modal-title" id="myModalLabel">Agregar Actividad</h4>
								</div>
								<?php echo form_open('actividades/agregar','class="form-horizontal"'); ?>
								<div class="modal-body">
									<div class="form-group">
										<label for="nombre" class="col-sm-2 control-label">Nombre</label>
										<div class="col-sm-10">
											<input type="text" class="form-control" id="nombre" name="nombre" placeholder="Ingrese actividad">
										</div>
									</div>
									<div class="form-group">
										<label for="instructor" class="col-sm-2 control-label">Instructor</label>
										<div class="col-sm-10">
											<select class="form-control" id="instructor" name="instructor">
												<option value='0'>---</option>
												<?php
												if(isset($instructores)){
													foreach ($instructores as $datos ) {?>
													<option value="<?= $datos['usuario_id']?>"><?=$datos['nombre_completo']?></option> 
													<?php }}  
													?>
												</select>
										</div>
										</div>
										<div class="form-group">
											<label for="descripcion" class="col-sm-2 control-label">Descripcion</label>
											<div class="col-sm-10">
												<textarea class="form-control" id="descripcion" name="descripcion" rows="5"></textarea>
											</div>
										</div>
										<div class="form-group">
											<label for="fecha" class="col-sm-2 control-label">Fecha Inicio</label>
											<div class="col-sm-10">
												<input type="date" class="form-control" id="fecha" name ="fecha" placeholder="Seleccione fecha">
											</div>
										</div>
									</div>
									<div class="modal-footer">
										<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
										<button type="submit" class="btn btn-primary">Guardar</button>
									</div>
									<?php echo form_close(); ?>
								</div>
							</div>
						</div>

						<div class="table-responsive col-sm-12">
							<?php
							if(isset($actividades)){
								$this->table->set_heading(array('#', 'Actividad', 'Descripcion', 'Instructor', ""));
								foreach ($actividades as $act_item) {
									$this->table->add_row(array(
										$act_item['id'],
										$act_item['nombre'],
										$act_item['descripcion'],
										$act_item["instructor"],
										anchor("actividades/lista_inscriptos/{$act_item['id']}", '<i class="glyphicon glyphicon-list"></i>', array('class' => 'btn btn-info btn-sm', 'role' => 'button', 'title' => 'Lista de inscriptos')) . " " . 
										'<button type="button" class="btn btn-info btn-sm btnModificarActividad" data-toggle="modal" data-target="#modificarModal" title="Modificar"><i class="glyphicon glyphicon-pencil"></i></button>' . " " . 
										anchor("actividades/eliminar/{$act_item['id']}", '<i class="glyphicon glyphicon-trash"></i>', array('onclick'=>"return confirm('¿Está seguro que desea eliminar {$act_item['nombre']}?')", 'class' => 'btn btn-danger btn-sm', 'role' => 'button', 'title' => 'Eliminar'))
									));
								}
								echo $this->table->generate();
							} 
							?>
						</div>
						<!-- /.table-responsive -->
						<div class="col-sm-6">
							<!-- Button trigger modal -->
							<button type="button" class="btn btn-primary" data-toggle="modal" data-target="#myModal">
								<i class="glyphicon glyphicon-plus"></i> Agregar Actividad
							</button>
						</div>
						<!-- Modal -->
						<div class="modal fade" id="modificarModal" tabindex="-1" role="dialog" aria-labelledby="modificarModalLabel" aria-hidden="true">
							<div class="modal-dialog">
								<div class="modal-content">
									<div class="modal-header">
										<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
										<h4 class="modal-title" id="modificarModalLabel">Modificar Actividad</h4>
									</div>
									<?php echo form_open('actividades/modificar','class="form-horizontal"'); ?>
									<div class="modal-body">
                						<input type="hidden" id="inputIdMod" name="idMod" value="">
										<div class="form-group">
											<label for="nombre" class="col-sm-2 control-label">Nombre</label>
											<div class="col-sm-10">
												<input type="text" class="form-control" id="nombreMod" name="nombreMod" placeholder="Ingrese actividad">
											</div>
										</div>
										<div class="form-group">
											<label for="instructor" class="col-sm-2 control-label">Instructor</label>
											<div class="col-sm-10">
												<select class="form-control" id="instructorMod" name="instructorMod">
												<option value='0'>---</option>
												<?php
												if(isset($instructores)){
													foreach ($instructores as $datos ) {?>
													<option value="<?= $datos['usuario_id']?>"><?=$datos['nombre_completo']?></option> 
													<?php }}  
													?>
												</select>
											</div>
										</div>
										<div class="form-group">
											<label for="descripcion" class="col-sm-2 control-label">Descripcion</label>
											<div class="col-sm-10">
												<textarea class="form-control" id="descripcionMod" name="descripcionMod" rows="5"></textarea>
											</div>
										</div>
										<div class="form-group">
											<label for="fecha" class="col-sm-2 control-label">Fecha Inicio</label>
											<div class="col-sm-10">
												<input type="date" class="form-control" id="fechaMod" name ="fechaMod" placeholder="Seleccione fecha">
											</div>
										</div>
									</div>
									<div class="modal-footer">
										<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
										<button type="submit" class="btn btn-primary">Guardar</button>
									</div>
									<?php echo form_close(); ?>
								</div>
							</div>
						</div>
						<!-- /.modal -->
					</div>
					<!-- /.row -->
				</div>
				<!-- /.container-fluid -->
			</div>
		</div>
	</div>





	</body>

	<?php $this->load->view('templates/scripts');?>
	<script>
		$(document).ready(function() {
			$(".btnModificarActividad").click(function() {
				var tableData = $(this).closest("tr").children("td").map(function() {
					return $(this).text();
				}).get();
                $("#inputIdMod").val($.trim(tableData[0]));
				$("#nombreMod").val($.trim(tableData[1]));
				$("#descripcionMod").val($.trim(tableData[2]));
				$("#instructorMod option").filter(function() {
					return($(this).text() == $.trim(tableData[3]))
				}).prop('selected', true);
			})
		});	
	</script>
	</html>
