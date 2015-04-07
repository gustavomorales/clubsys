<?php if ( ! defined('BASEPATH')) exit ('No direct script access allowed');
class Socios_model extends CI_model {
	public function __construct() {
		$this->load->database();
	}

	public function set_socios($data) {
		$tipo = $data['tipo'];
		$nombres = $data['nombres'];
		$apellido = $data['apellido'];
		$direccion = $data['direccion'];
		$fechaNacimiento = $data['fechaNacimiento'];
		$dni = $data['dni'];

		$existe = $this->db->get_where('usuario', array('dni' => $dni));
		if ($existe->result_array()) {
			return array('danger',"Ya hay un socio con el mismo DNI ({$dni}).");
		}
		else {
			$this->db->query("call agregar_usuario('{$tipo}', '{$nombres}', '{$apellido}', '1234', '{$direccion}', '{$fechaNacimiento}', '{$dni}')");

			if($this->db->affected_rows() > 0) {
				return array('success', 'Socio creado con &eacute;xito');
			} else {
				return array('danger', 'Error al intentar crear socio.');
			}
		}
	}

	public function get_socios($string = FALSE) {	
		$query_string = "SELECT * FROM `lista_usuarios`";

		if ($string) {
			$query_string .= " WHERE `nombre_completo` LIKE '%{$string}%'";
		}

		$query = $this->db->query($query_string);

		return $query->result_array();
	}

	public function get_sociosxtipo($tipoId) {
		$this->db->select('*');
		$this->db->from('lista_usuarios');
		$this->db->where("tipo_id = {$tipoId}");
		$query = $this->db->get();

		return $query->result_array();
	}
	public function update_socio($data, $dniActual) {

		$info = array(
			'tipo_id' => $data['tipo'],
			'nombres' => $data['nombres'],
			'apellido' => $data['apellidos'],
			'direccion' => $data['direccion'],
			'fecha_nacimiento' => $data['nacimiento'],
			'dni' => $data['dni']
			);

		if ($info['dni'] != $dniActual) {
			$existe = $this->db->get_where('usuario', array('dni' => $info['dni']));
			if ($existe->result_array()) {
				$mensaje = htmlentities("Ya existe otro socio con el mismo DNI ({$info["dni"]}).", ENT_COMPAT, 'UTF-8');
				return array('danger', $mensaje);
			}
		}

		$this->db->where('id', $data['id']);
		$this->db->update('usuario', $info); 

		return array('success', 'Socio modificado con &eacute;xito');
		
	}

	public function get_tipos(){
		$query = $this->db->get('tipo_usuario');

		return $query->result_array();
	}

	public function delete_socio($id) {
		$this->db->delete('usuario', array('id' => $id));
		if ($this->db->affected_rows() > 0)
			return array('success', 'Socio eliminado exitosamente.');
		else
			return array('danger', "Error al intentar eliminar socio (id: {$id}).");
	}

	public function get_socio_id($id){
		$query=$this->db->get_where('usuario',array('id'=>$id));


		return $query->result_array();
	}

}