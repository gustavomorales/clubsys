	 <!-- Navigation -->
     <nav class="navbar navbar-inverse navbar-fixed-top" role="navigation">
		<div class="container-fluid">
			<div class="navbar-header">
				<button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
					<span class="sr-only">Toggle navigation</span>
					<span class="icon-bar"></span>
					<span class="icon-bar"></span>
					<span class="icon-bar"></span>
				</button>
				<?php echo anchor('', 'ClubSys', 'class="navbar-brand"'); ?>
			</div>
			<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
				<ul class="nav navbar-nav">
					<li>
						<?php echo anchor('home', 'Inicio'); ?>
					</li>
				</ul>
				<?php
				if (!$this->session->userdata('username')):
					echo anchor('usuarios/login', 'Iniciar sesión', 'class="btn btn-default navbar-btn"');
				else:
					echo anchor('usuarios/logout', 'Cerrar sesión', 'class="btn btn-default navbar-btn"');
				endif; 
				?>
			</div>
		</div>
	</nav>