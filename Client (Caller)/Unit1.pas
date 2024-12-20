unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, unaVC_socks, unaVCIDE,
  unaVC_wave, unaVC_pipe, unaSockets, Vcl.Samples.Spin, unaVCIDEutils;

type
  TForm1 = class(TForm)
    waveIn: TunavclWaveInDevice; // Audio input device (microphone)
    codecIn: TunavclWaveCodecDevice; // Audio codec for encoding/decoding
    ipClient: TunavclIPOutStream; // IP client stream for VOIP
    Button1: TButton; // Codec for audio output
    Button2: TButton; // Button to stop connection
    Label1, Label2, Label3, Label4: TLabel; // UI labels
    SpinEdit1: TSpinEdit; // For entering the port number
    Edit1, Edit2: TEdit; // Edit1 for IP, Edit2 for chat input
    ComboBox1: TComboBox; // List of audio input devices
    RadioButton1, RadioButton2: TRadioButton; // Protocol selection (TCP/UDP)
    Memo1: TMemo; // Log for connection status
    Memo2: TMemo; // Chat display area
    GroupBox1: TGroupBox;
    Button3: TButton; // Send message button
    procedure Button1Click(Sender: TObject); // Start connection
    procedure ipClientClientDisconnect(Sender: TObject; connId: tConID;
      connected: bool); // Handle disconnection
    procedure ipClientClientConnect(Sender: TObject; connId: tConID;
      connected: bool); // Handle new connection
    procedure Button2Click(Sender: TObject); // Stop connection
    procedure ipClientTextData(Sender: TObject; connId: tConID;
      const data: string); // Receive text data from server
    procedure FormCreate(Sender: TObject); // Initialization
    procedure ComboBox1Change(Sender: TObject); // Audio input device selection
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    // Handle form close
    procedure Button3Click(Sender: TObject); // Send chat message
  private
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

// Helper procedure to close the client connection and release resources gracefully
procedure GracefullyShutdownClient;
begin
  Form1.waveIn.close(); // Close microphone input
  Form1.Button1.Enabled := true; // Enable connect button
  Form1.Button2.Enabled := false; // Disable disconnect button
  Form1.ipClient.active := false; // Deactivate client stream
  Form1.Label3.Caption := 'Not In Call'; // Update status label
  Form1.Radiobutton1.Enabled:=True;
  Form1.Radiobutton2.Enabled:=True;
end;

// Start connection when Button1 is clicked
procedure TForm1.Button1Click(Sender: TObject);
begin
  // Set the server's IP and port from user input
  ipClient.host := Edit1.Text;
  ipClient.port := IntToStr(SpinEdit1.Value);

  // Configure protocol based on selected radio button
  if RadioButton1.Checked then
    ipClient.proto := unapt_TCP
  else if RadioButton2.Checked then
    ipClient.proto := unapt_UDP;

  // Set up audio streaming by linking codec and client
  codecIn.consumer := ipClient;
  //ipClient.consumer := CodecOut; //NOT NEEDED! Leaving here for FULL DUPLEX future updates!
  // Open the audio input for recording
  codecIn.open();
  waveIn.open();
  ipClient.active := true; // Activate client connection
  ComboBox1.Enabled := false;
  // Disable device selection ComboBox during connection

  Radiobutton1.Enabled:=false;
  Radiobutton2.Enabled:=false;
end;

// Stop connection when Button2 is clicked
procedure TForm1.Button2Click(Sender: TObject);
begin
  GracefullyShutdownClient; // Gracefully close the connection
  ComboBox1.Enabled := true; // Enable device selection ComboBox
end;

// Send chat message when Button3 is clicked
procedure TForm1.Button3Click(Sender: TObject);
begin
  Memo2.Lines.Add('You Said: ' + Edit2.Text);
  // Display user's message in chat log
  ipClient.sendText(0, 'Client Says: ' + Edit2.Text);
  // Send the message to server
  Edit2.Clear; // Clear input field
  Edit2.SetFocus; // Set focus back to input field
end;

// Change audio input device based on ComboBox selection
procedure TForm1.ComboBox1Change(Sender: TObject);
begin
  waveIn.deviceId := ComboBox1.ItemIndex;
  // Set input device to selected ComboBox item
end;

// Gracefully shut down client when the form closes
procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    if ipClient.active then
    begin
     GracefullyShutdownClient; // Gracefully close the connection
     ComboBox1.Enabled := true; // Enable device selection ComboBox
    end;

  end;

// Initialize the form
procedure TForm1.FormCreate(Sender: TObject);
begin

  // Populate ComboBox with available audio input devices
  enumWaveDevices(ComboBox1, true);
  if ComboBox1.Items.Count > 0 then
    ComboBox1.ItemIndex := 0; // Set the first device as default
  Memo1.Lines.Add('Application Started'); // Log start message
end;

// Handle client connection to server
procedure TForm1.ipClientClientConnect(Sender: TObject; connId: tConID;
  connected: bool);
begin
  Button1.Enabled := false; // Disable connect button
  Button2.Enabled := true; // Enable disconnect button
  Label3.Caption := 'In Call!'; // Update status label
  Memo1.Lines.Add('Connected To Server!'); // Log connection

  // enable chat controls...
  Button3.Enabled := true;
  Edit2.Enabled := true;
end;

// Handle client disconnection from server
procedure TForm1.ipClientClientDisconnect(Sender: TObject; connId: tConID;
  connected: bool);
begin
  GracefullyShutdownClient; // Clean up resources
  Memo1.Lines.Add('Disconnected From Server!'); // Log disconnection

  // disable and clear chat controls...
  Button3.Enabled := false;
  Edit2.Enabled := false;
  Memo2.Clear;
  ComboBox1.Enabled := true; // Enable device selection ComboBox
  Radiobutton1.Enabled:=True;
  Radiobutton2.Enabled:=True;
end;

// Handle incoming text data from server
procedure TForm1.ipClientTextData(Sender: TObject; connId: tConID;
  const data: string);
begin
  // If server sends an "ENDCALL" message, terminate the call
  if data = 'ENDCALL' then
    GracefullyShutdownClient
    // If server sends a chat message, display it in Memo2
  else if data.Contains('Server Says:') then
    Memo2.Lines.Add(data);
end;

end.
