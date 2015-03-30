
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

		if($this->form_validation->run()!=false){

			$nombre=$_POST['nombre'];
			$descripcion=$_POST['descripcion'];
			$fecha=$_POST['fecha'];
			$instructor=$_POST['instructor'];

			$data=array ('nombre'=>$nombre,'descripcion'=>$descripcion,'instructor'=>$instructor,'fecha'=>$fecha);

			if ($this->actividades_model->set_actividad($data))
				$this->session->set_flashdata('success', 'Actividad agregada con &eacute;xito.');
			else
				$this->session->set_flashdata('danger', 'Error al agregar actividad.');

			redirect('actividades/index');
		}
		else
		{
			$this->session->set_flashdata('warning', validation_errors());
			redirect('actividades');
		}
	}

	public function eliminar($id) {
		if ($this->actividades_model->delete_actividad($id))
			$this->session->set_flashdata('success', 'Actividad eliminada con &eacute;xito.');
		else
			$this->session->set_flashdata('danger', 'No se encontr&oacute; la actividad con el id correspondiente.');

		redirect('actividades/index');
	}

	public function modificar(){

		$id = $this->input->post('idMod');
		$nombre= $this->input->post('nombreMod');
		$instructor= $this->input->post('instructorMod');
		$descripcion= $this->input->post('descripcionMod');
		$fecha= $this->input->post('fechaMod');

		$data=array('id'=>$id,'nombre'=>$nombre,'instructor'=>$instructor,'descripcion'=>$descripcion);

		if($this->actividades_model->update_actividad($data))
			$this->session->set_flashdata('success', 'Actividad actualizada con &eacute;xito.');
		else
			$this->session->set_flashdata('danger', 'Error al modificar actividad.');

			redirect('actividades/index');

	}
}