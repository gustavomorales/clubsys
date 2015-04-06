<!DOCTYPE html>
<html lang="es">
<head>
	<title>Home</title>
	<?php $this->load->view('templates/head'); ?>
</head>
<body>
	<?php $this->load->view('templates/nav'); ?>
	<div id="page-wrapper">
		<div class="container">
		<div class="row">
			<h1 class="text-center">ClubSys</h1>

			<article class="col-sm-6">
			<h3>Quiénes somos</h3>
			<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec consequat pharetra luctus. Ut a rhoncus risus, 
				egestas sodales nibh. Vestibulum eget turpis malesuada, gravida turpis id, ultrices dui. Vestibulum sodales 
				urna arcu, id tincidunt ante vulputate non. Donec vehicula, quam in venenatis aliquam, metus odio malesuada 
				diam, sed ornare elit urna sed lacus. Donec elit leo, suscipit nec neque vel, accumsan vestibulum lorem. 
				Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Pellentesque 
				imperdiet tincidunt egestas. In vel nulla et tellus interdum tempus. Pellentesque sagittis orci ac diam rutrum,
				 ultricies euismod metus facilisis. Fusce volutpat nibh cursus lectus porta congue. Nullam mollis scelerisque 
				 elit, id lobortis nibh. Donec ut est orci. Nulla nec mi id turpis rhoncus euismod in in metus. Fusce non 
				 gravida metus.</p>
			<?php echo anchor('#', 'Ver más', array('class' => 'btn btn-primary', 'role' => 'button')) ?>
			</article>

			<article class="col-sm-6">
			<h3>Novedades</h3>
			<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec consequat pharetra luctus. Ut a rhoncus risus, 
				egestas sodales nibh. Vestibulum eget turpis malesuada, gravida turpis id, ultrices dui. Vestibulum sodales 
				urna arcu, id tincidunt ante vulputate non. Donec vehicula, quam in venenatis aliquam, metus odio malesuada 
				diam, sed ornare elit urna sed lacus. Donec elit leo, suscipit nec neque vel, accumsan vestibulum lorem. 
				</p>
			<?php echo anchor('#', 'Ver más', array('class' => 'btn btn-primary', 'role' => 'button')) ?>
			</article>

			<article class="col-sm-6">
			<h3>Novedades</h3>
			<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut a rhoncus risus, 
				egestas sodales nibh. Vestibulum eget turpis malesuada, gravida turpis id, ultrices dui. 
				Donec vehicula, quam in venenatis aliquam, metus odio malesuada 
				diam, sed ornare elit urna sed lacus. Donec elit leo, suscipit nec neque vel, accumsan vestibulum lorem. 
				</p>
			<?php echo anchor('#', 'Ver más', array('class' => 'btn btn-primary', 'role' => 'button')) ?>
			</article>
		</div>
	</div>
	<?php $this->load->view('templates/footer'); ?>
	<?php $this->load->view('templates/scripts'); ?>
</body>
</html>