
<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Actividades extends CI_Controller {

	public function __construct(){
		parent::__construct();
		$this->load->model('actividades_model');
		$this->load->model('socios_model');
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
		$this->form_validation->set_rules('nombre','Nombre','required[actividad.nombre]');
		$this->form_validation->set_rules('descripcion','Descripcion','required');
		$this->form_validation->set_rules('fecha','Fecha','required');

		if($this->form_validation->run()!=false){

			$nombre=$_POST['nombre'];
			$descripcion=$_POST['descripcion'];
			$fecha=$_POST['fecha'];
			$instructor=$_POST['instructor'];

			$data=array ('nombre'=>$nombre,'descripcion'=>$descripcion,'instructor'=>$instructor,'fecha'=>$fecha);

			$mensaje = $this->actividades_model->set_actividad($data);
			
			$this->session->set_flashdata($mensaje[0], $mensaje[1]);
			
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
		$nombreActual = $this->input->post('nombreActual');

		$data=array('id'=>$id,'nombre'=>$nombre,'instructor'=>$instructor,'descripcion'=>$descripcion);

		$mensaje = $this->actividades_model->update_actividad($data, $nombreActual);
		$this->session->set_flashdata($mensaje[0], $mensaje[1]);
			
		redirect('actividades/index');

	}
	public function baja($id_actividad, $id_usuario) {
		$mensaje = $this->actividades_model->desinscribir_actividad($id_usuario,$id_actividad);
		$this->session->set_flashdata($mensaje[0], $mensaje[1]);

		redirect("actividades/lista_actividades/{$id_usuario}");
	}

	public function baja2($id_actividad, $id_usuario) {
		$mensaje = $this->actividades_model->desinscribir_actividad($id_usuario,$id_actividad);
		$this->session->set_flashdata($mensaje[0], $mensaje[1]);

		redirect("actividades/lista_inscriptos/{$id_actividad}");


	}

	public function lista_actividades($id){

		$datos['lactividades']= $this->actividades_model->get_actividades_usuario($id);
		$datos['actividades']=$this->actividades_model->get_actividades();
		$datos['getsocio']=$this->socios_model->get_socio_id($id);
		$this->load->view('pages/listadeactividades',$datos);


	}

	public function lista_inscriptos($id){
		$datos['linscriptos']=$this->actividades_model->get_usuarios_actividad($id);
		$this->load->view('pages/listadeinscriptos',$datos);
	}

	public function alta() {

		$this->form_validation->set_rules('usuario','Usuario','required');
		$this->form_validation->set_rules('actividades','Actividades','required');

		if($this->form_validation->run()!=false){

			$id_usuario=$this->input->post('usuario');
			$id_actividad=$this->input->post('actividades');
			if($id_actividad != 0) {
				$mensaje = $this->actividades_model->inscribir_actividad($id_usuario,$id_actividad);
				$this->session->set_flashdata($mensaje[0], $mensaje[1]);
			}
			else
				$this->session->set_flashdata('warning','Seleccione una Actividad');
		}
		redirect("actividades/lista_actividades/{$id_usuario}");
	}
}