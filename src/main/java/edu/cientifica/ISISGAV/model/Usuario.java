package edu.cientifica.ISISGAV.model;

import java.util.List;

public class Usuario {

	private int id_Usuario;
	private Empleado empleado;
	private String usuario;
	private String pass;
	private List<Tipo_Usuario> tipo_Usuario;

	public int getId_Usuario() {
		return id_Usuario;
	}

	public void setId_Usuario(int id_Usuario) {
		this.id_Usuario = id_Usuario;
	}

	public Usuario(int id_Usuario, Empleado empleado, String usuario, String pass, List<Tipo_Usuario> tipo_Usuario) {
		super();
		this.id_Usuario = id_Usuario;
		this.empleado = empleado;
		this.usuario = usuario;
		this.pass = pass;
		this.tipo_Usuario = tipo_Usuario;
	}
	
	public Usuario(String usuario, String pass) {
		super();
		this.usuario = usuario;
		this.pass = pass;
	}

	public Usuario() {
		super();
	}

	public Empleado getEmpleado() {
		return empleado;
	}

	public void setEmpleado(Empleado empleado) {
		this.empleado = empleado;
	}

	public String getUsuario() {
		return usuario;
	}

	public void setUsuario(String usuario) {
		this.usuario = usuario;
	}

	public String getPass() {
		return pass;
	}

	public void setPass(String pass) {
		this.pass = pass;
	}

	public List<Tipo_Usuario> getTipo_Usuario() {
		return tipo_Usuario;
	}

	public void setTipo_Usuario(List<Tipo_Usuario> tipo_Usuario) {
		this.tipo_Usuario = tipo_Usuario;
	}

}
