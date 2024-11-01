unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  unaVC_wave, unaVCIDE, unaVC_socks, Vcl.StdCtrls, unaSockets, unaVC_pipe,
  unaVCIDEutils;

type
  TForm1 = class(TForm)
    GroupBox2: TGroupBox;
    ipServer: TunavclIPInStream; // Server component for managing incoming IP streams
    codecOut: TunavclWaveCodecDevice; // Codec device for audio encoding/decoding
    waveOut: TunavclWaveOutDevice; // Output device for audio playback
    Button2: TButton; // Button to start the server
    Button3: TButton; // Button to stop the server
    Memo1: TMemo; // Memo field for logging server activities
    Label3: TLabel; // Label to show call status
    Label1: TLabel; // Label for server configuration
    ComboBox1: TComboBox; // Dropdown for selecting audio output device
    RadioButton1: TRadioButton; // TCP protocol selection
    RadioButton2: TRadioButton; // UDP protocol selection
    GroupBox1: TGroupBox; // Group box for server settings
    Button1: TButton; // Button to send a message
    Edit1: TEdit; // Text input for messages
    Memo2: TMemo; // Memo for displaying chat messages
    procedure Button2Click(Sender: TObject); // Event handler to start server
    procedure Button3Click(Sender: TObject); // Event handler to stop server
    procedure FormCreate(Sender: TObject); // Initializes form on create
    procedure ipServerServerNewClient(Sender: TObject; connId: tConID;
      connected: bool); // Handler for new client connections
    procedure ipServerServerClientDisconnect(Sender: TObject; connId: tConID;
      connected: bool); // Handler for client disconnections
    procedure ComboBox1Change(Sender: TObject); // Changes output device
    procedure FormClose(Sender: TObject; var Action: TCloseAction); // Handles form close event
    procedure Button1Click(Sender: TObject); // Sends message to connected client
    procedure ipServerTextData(Sender: TObject; connId: tConID;
      const data: string); // Handles incoming text data from clients
  private
    procedure StartServer; // Starts the server with the set parameters
    procedure StopServer; // Stops the server and resets controls
  public
    RemoteIP: string; // Holds IP address of connected client
    RemotePort: string; // Holds port of connected client
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.StartServer;
begin
  // Configure server's IP and port
  ipServer.port := '3434'; // Set server port
  ipServer.bindTo := '0.0.0.0'; // Bind server to all available network interfaces

  // Set protocol based on user selection (TCP or UDP)
  if RadioButton1.Checked then
    ipServer.proto := unapt_TCP;
  if RadioButton2.Checked then
    ipServer.proto := unapt_UDP;



  // Connect codec output to audio playback device
  codecOut.consumer := waveOut;
  ipServer.consumer := codecOut;

  // Start audio output, codec, and activate server
  waveOut.open();
  codecOut.open();
  ipServer.active := true;

  // Log server start and adjust button states
  Memo1.Lines.Add('Server started on port 3434');
  Button2.Enabled := false; // Disable start button
  Button3.Enabled := true;  // Enable stop button
  Radiobutton1.Enabled:=false;
  Radiobutton2.Enabled:=false;
end;

procedure TForm1.StopServer;
begin
  // Deactivate server and close audio devices
  ipServer.active := false;
  waveOut.close();
  codecOut.close();

  // Log server stop event and reset button states
  Memo1.Lines.Add('Server stopped');
  Button2.Enabled := true;  // Enable start button
  Button3.Enabled := false; // Disable stop button
  Radiobutton1.Enabled:=True;
  Radiobutton2.Enabled:=True;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  // Send message to client and log it in the chat memo
  Memo2.Lines.Add('You Said: ' + Edit1.Text);
  ipServer.sendText(0, 'Server Says: ' + Edit1.Text);
  Edit1.Clear;  // Clear input field after sending
  Edit1.SetFocus; // Focus back to input field
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  // Start server if it is currently inactive
  if not ipServer.active then
    StartServer;
  ComboBox1.Enabled := false; // Disable device selection while server is running
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  // Send ENDCALL message if a client is connected
  if ipServer.clientCount > 0 then
  begin
    ipServer.sendText(0, 'ENDCALL');
    Memo1.Lines.Add('ENDCALL command sent to client');
  end;

  StopServer; // Stop server operation
  ComboBox1.Enabled := true; // Re-enable output device selection
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
begin
  // Change audio output device based on ComboBox selection
  waveOut.deviceId := ComboBox1.ItemIndex;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // Send ENDCALL if any client is connected during form close
  if ipServer.clientCount > 0 then
  begin
    ipServer.sendText(0, 'ENDCALL');
    Memo1.Lines.Add('ENDCALL command sent to client');
  end;

  // Ensure server is stopped before closing form
  if ipServer.active then
    StopServer;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  // Clear and log initial start message
  Memo1.Clear;
  Memo1.Lines.Add('Application started');

  // Enumerate available output devices and populate ComboBox
  ComboBox1.Items.Clear;
  enumWaveDevices(ComboBox1, false);

  // Set default device if available
  if ComboBox1.Items.Count > 0 then
    ComboBox1.ItemIndex := 0;
end;

procedure TForm1.ipServerServerClientDisconnect(Sender: TObject;
  connId: tConID; connected: bool);
begin
  // Log client disconnection and clear IP/port details
  Memo1.Lines.Add('Client Disconnected From IP: ' + RemoteIP);
  RemoteIP := '';
  RemotePort := '';
  Label3.Caption := 'Not In Call'; // Update call status

  // Disable chat controls and clear chat memo
  self.Button1.Enabled := false;
  self.Edit1.Enabled := false;
  self.Memo2.Clear;
end;

procedure TForm1.ipServerServerNewClient(Sender: TObject;
  connId: tConID; connected: bool);
begin
  // Retrieve and log client's IP and port details
  ipServer.getHostInfo(RemoteIP, RemotePort, connId);
  Memo1.Lines.Add('New Client Connected From IP: ' + RemoteIP);
  Label3.Caption := 'In Call!'; // Update call status

  // Enable chat controls for communication
  self.Button1.Enabled := true;
  self.Edit1.Enabled := true;
end;

procedure TForm1.ipServerTextData(Sender: TObject; connId: tConID;
  const data: string);
begin
  // Display incoming message from client with "Client Says:" prefix
  if data.Contains('Client Says:') then
    Memo2.Lines.Add(Data);
end;

end.

