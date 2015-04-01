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
							Lista de Inscriptos
							<small></small>
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
							
				</div>

					<div class="table-responsive col-sm-12">
							<?php
							if(isset($linscriptos)){
								$this->table->set_heading(array('Actividad','Participantes', ""));
								foreach ($linscriptos as $act_item) {
									$this->table->add_row(array(
										$act_item['actividad'],
										$act_item['participante'],
										anchor("actividades/baja2/{$act_item['actividad_id']}/{$act_item['usuario_id']}", '<i class="glyphicon glyphicon-trash"></i>', array('onclick'=>"return confirm('¿Está seguro de dar de baja al socio {$act_item['participante']}?')", 'class' => 'btn btn-danger btn-sm', 'role' => 'button', 'title' => 'Eliminar'))
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
