
<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Actividades extends CI_Controller {

	public function __construct(){
		parent::__construct();
		$this->load->model('actividades_model');
		$this->load->library('form_validation');
		$this->load->library('table');
  		$template = array('table_open' => "<table class='table table-condensed table-striped'");
  		$this->table->set_template($template);

	}	

	public function index()
	{	
		$datos['actividades']=$this->actividades_model->get_actividades();
		$datos['instructores']=$this->actividades_model->get_instructores();
		$this->load->view('pages/actividades',$datos);
	}

	public function agregar(){
		$this->form_validation->set_rules('nombre','Nombre','required|is_unique[actividad.nombre]');
		$this->form_validation->set_rules('descripcion','Descripcion','required');
		$this->form_validation->set_rules('fecha','Fecha','required');
		#$this->form_validation->set_message('required','El campo %s es obligatorio');
		#$this->form_validation->set_message('is_unique','El campo %s debe ser unico');

		if($this->form_validation->run()!=false){

			$nombre=$_POST['nombre'];
			$descripcion=$_POST['descripcion'];
			$fecha=$_POST['fecha'];
			$instructor=$_POST['instructor'];

			$data=array ('nombre'=>$nombre,'descripcion'=>$descripcion,'instructor'=>$instructor,'fecha'=>$fecha);

			$this->actividades_model->set_actividad($data);
			$datos['actividades']=$this->actividades_model->get_actividades();
			$datos['mensaje']='<p>Actividad Agregada</p>';
			$datos['instructores']=$this->actividades_model->get_instructores();
			redirect('actividades');
		}
		else
		{
			$datos['actividades']=$this->actividades_model->get_actividades();	
			$datos['mensaje']='<p>Validación incorrecta</p>';
			$datos['instructores']=$this->actividades_model->get_instructores();
			$this->load->view('pages/actividades',$datos);
		}
	}

	public function eliminar($id) {
		if ($this->actividades_model->delete_actividad($id)) {
			$this->session->set_userdata('success', 'Actividad eliminada con éxito.');
			redirect('actividades/index');

		}
		else {
			$this->session->set_userdata('error', 'No se encontró la actividad con el id correspondiente.');
			redirect('actividades/index');
		}

	}
}