<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');
class Socios extends CI_Controller {
	public function __construct() {
		parent::__construct();
		$this->load->model('socios_model');
		$this->load->helper('form');
		$this->load->library('form_validation');
		$this->load->library('table');
		$template = array('table_open' => "<table class='table table-condensed table-striped'");
		$this->table->set_template($template);
	}
	public function index() {
		$this->form_validation->set_rules('busqueda', 'Búsqueda', 'required|alpha_numeric');

		if ($this->form_validation->run()) {
			$string = $this->input->post('busqueda');
			$data['socios'] = $this->socios_model->get_socios($string);

		}
		else {
			$data['socios'] = $this->socios_model->get_socios();
		}

		$data['tipos'] = $this->socios_model->get_tipos();
		$this->load->view('pages/socios', $data);
	}

	public function agregar() {
		$config = array(
			array(
				'field'   => 'nombres', 
				'label'   => 'Nombres', 
				'rules'   => 'required'
				),
			array(
				'field'   => 'apellidos', 
				'label'   => 'Apellidos', 
				'rules'   => 'required'
				),
			array(
				'field'   => 'direccion', 
				'label'   => 'Dirección', 
				'rules'   => 'required'
				),
			array(
				'field'   => 'fechaNacimiento', 
				'label'   => 'Fecha de nacimiento', 
				'rules'   => 'required'
				)
			);
		$this->form_validation->set_rules($config);

		if ($this->form_validation->run()) {
			$detalles = array(
				'nombres' => $this->input->post('nombres'),
				'apellido' => $this->input->post('apellidos'),
				'tipo' => $this->input->post('tipo'),
				'direccion' => $this->input->post('direccion'),
				'fechaNacimiento' => $this->input->post('fechaNacimiento')
				);
			
			$this->socios_model->set_socios($detalles);
			$this->index();
		}
		else {
			$this->index();
		}
	}

	public function modificar() {
		$config = array(
			array(
				'field'   => 'nombresMod', 
				'label'   => 'Nombres', 
				'rules'   => 'required'
				),
			array(
				'field'   => 'apellidosMod', 
				'label'   => 'Apellidos', 
				'rules'   => 'required'
				),
			array(
				'field'   => 'direccionMod', 
				'label'   => 'Dirección', 
				'rules'   => 'required'
				),
			array(
				'field'   => 'fechaNacimientoMod', 
				'label'   => 'Fecha de nacimiento', 
				'rules'   => 'required'
				)
			);
		$this->form_validation->set_rules($config);

		if ($this->form_validation->run()) {
			$detalles = array(
				'id' => $this->input->post('idMod'),
				'nombres' => $this->input->post('nombresMod'),
				'apellidos' => $this->input->post('apellidosMod'),
				'tipo' => $this->input->post('tipoMod'),
				'direccion' => $this->input->post('direccionMod'),
				'nacimiento' => $this->input->post('fechaNacimientoMod')
				);
			echo json_encode($detalles);die;
			$this->socios_model->update_socio($detalles);
			redirect('socios/index');
		}
		else {
			$this->session->set_flashdata('error', validation_errors());
			redirect('socios/index');
		}
	}

	public function eliminar($id) {
		$this->socios_model->delete_socio($id);
		redirect('socios/index');
	}
}