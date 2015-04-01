<!DOCTYPE html>
<html>
<head>
	<title>Lista de actividades</title>
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
							Lista de actividades
							<small><?= $getsocio[0]['apellido'] . ', ' . $getsocio[0]['nombres']?></small>
						</h1>
						<ol class="breadcrumb">
							<li>
								<i class="fa fa-dashboard"></i>  <?php echo anchor('dashboard', 'Dashboard');?>
							</li>
							<li>
								<i class="fa fa-file"></i> <?php echo anchor('actividades', 'Actividades');?>
							</li>
							<li class="active">
								<i class="fa fa-file"></i> Inscripciones
							</li>
						</ol>
					</div>
					<?php $this->load->view('templates/mensajes'); ?>
				<div class="col-sm-12">
					<?php echo form_open('actividades/alta','class="form-inline"'); ?>
						<div class="form-group">
							<input type="hidden" name="usuario" value=<?= $getsocio[0]['id'] ?>>
							<label for="actividades">Actividades</label>
							<select class="form-control" id="actividades" name="actividades">
							<option value='0'>---</option>
							<?php
							if(isset($actividades)){
								foreach ($actividades as $datos ) {?>
								<option value="<?= $datos['id']?>"><?=$datos['nombre']?></option> 
								<?php }}  
								?>
							</select>
						</div>
						<button type="submit" class="btn btn-primary">Asignar Actividad</button>
					<?php echo form_close(); ?>		

				</div>
							
				</div>

					<div class="table-responsive col-sm-12">
							<?php
							if(isset($lactividades)){
								$this->table->set_heading(array('Actividad', ""));
								foreach ($lactividades as $act_item) {
									$this->table->add_row(array(
										$act_item['actividad'],
										anchor("actividades/baja/{$act_item['actividad_id']}/{$getsocio[0]['id']}", '<i class="glyphicon glyphicon-trash"></i>', array('onclick'=>"return confirm('¿Está seguro de dar de baja {$act_item['actividad']}?')", 'class' => 'btn btn-danger btn-sm', 'role' => 'button', 'title' => 'Eliminar'))
									));
								}
								echo $this->table->generate();
							} 
							?>
						</div>
						<!-- /.table-responsive -->

				<!-- /.row -->
			</div>
			<!-- /.container-fluid -->
		</div>
		<!-- /.page-wrapper -->
	</div>
	<!-- /.wrapper -->
	<?php $this->load->view('templates/scripts');?>
</body>
</html>
