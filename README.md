<h1><span style="font-size: 24px; margin-right: 10px;">📞</span>Delphi VOIP and Chat Applications</h1>

<p>This repository contains two Delphi VCL projects designed for VOIP communication and real-time text chat using the <strong>VC (Voice Chat) components</strong> by LakeOfSoft. These components are included in this repository for your convenience, available in two versions:</p>
<ul>
  <li><strong>Version for Delphi 4 to Delphi XE3:</strong> This version is compatible with older Delphi environments.</li>
  <li><strong>Version for Delphi 12.2 Athens:</strong> A partially re-written and fixed version to ensure compatibility with the latest Delphi release.</li>
</ul>
<p>These applications facilitate audio streaming and messaging for a single-client server connection.</p>

<!-- Add a screenshot or preview image of the applications -->
<p align="center">
  <img src="Preview.png" alt="Screenshot of Delphi VOIP and Chat Applications" style="max-width:100%; height:auto;">
</p>

<h2><span style="font-size: 20px; margin-right: 10px;">📋</span>Projects Overview</h2>
<ul>
  <li><strong>VOIP Server Project:</strong> Handles a single client connection for audio streaming and basic text chat functionality.</li>
  <li><strong>VOIP Client Project:</strong> Connects to the server, allowing audio streaming from the client's microphone to the server and basic text-based chat.</li>
</ul>

<h2><span style="font-size: 20px; margin-right: 10px;">✨</span>Features</h2>
<ul>
  <li><strong>Audio Streaming:</strong> The client sends microphone audio to the server, which plays the audio through the user's preferred output device in Microsoft Windows.</li>
  <li><strong>Real-Time Text Chat:</strong> Allows for messaging between the client and server in real-time.</li>
  <li><strong>Protocol Flexibility:</strong> Supports both TCP and UDP communication modes.</li>
  <li><strong>Single Client Connection:</strong> Server accepts only one client connection at a time for focused communication.</li>
  <li><strong>Configurable Bitrate:</strong> By default, the components are set to their standard PCM bitrate. Users can easily add code to modify the bitrate as needed to suit different audio quality requirements.</li>
</ul>

<h2><span style="font-size: 20px; margin-right: 10px;">🔄</span>Full Duplex Capability</h2>
<p>While the current setup facilitates unidirectional audio streaming—where the client sends audio to the server—users can easily modify the application to create a full-duplex solution. This means both the client and server can simultaneously send and receive audio.</p>
<ul>
  <li><strong>Client Modifications:</strong> Update the client to handle audio input and output. By integrating the audio streaming logic for both sending and receiving, you can allow the client to capture audio from the microphone and play audio received from the server.</li>
  <li><strong>Server Modifications:</strong> The server will need to support multiple streams—receiving audio from the client while sending audio back. By implementing a two-way communication channel, the server can relay audio packets back to the client.</li>
  <li><strong>Synchronization:</strong> Ensure proper synchronization of audio streams to prevent echo and latency issues, possibly using audio buffering techniques.</li>
</ul>
<p>By implementing these modifications, users can transform the current application into a robust full-duplex VOIP solution.</p>

<h2><span style="font-size: 20px; margin-right: 10px;">⚙️</span>Installation</h2>
<ol>
  <li><strong>Requirements:</strong> Delphi with the VC (Voice Chat) components included in this repository, located in the <code>VC Audio Components For Delphi</code> folder, for audio and socket operations.</li>
  <li><strong>Download and Open Project:</strong> Clone this repository and open the .dpr files in Delphi for each project.</li>
  <li><strong>Compile:</strong> Build both projects to generate the executables for the client and server.</li>
  <li><strong>Run:</strong> Start the server application first, followed by the client.</li>
</ol>

<h2><span style="font-size: 20px; margin-right: 10px;">🔌</span>Usage</h2>
<ol>
  <li><strong>Server Setup:</strong> Enter a port and start the server to listen for an incoming connection.</li>
  <li><strong>Client Connection:</strong> Enter the server's IP address and port on the client, select TCP or UDP, and connect.</li>
  <li><strong>Audio and Chat:</strong> Use the client’s chat interface to send text messages and the integrated audio devices for VOIP streaming.</li>
  <li><strong>Adjusting Bitrate:</strong> To change the default PCM bitrate, add custom code to the audio component settings in Delphi for enhanced audio quality control.</li>
  <li><strong>Disconnection:</strong> Click the disconnect button on the client to end the connection gracefully.</li>
</ol>

<h2><span style="font-size: 20px; margin-right: 10px;">🤝</span>Contributing</h2>
<p>Contributions are welcome! Please fork this repository, make your changes, and submit a pull request with any bug fixes or enhancements.</p>

<h2><span style="font-size: 20px; margin-right: 10px;">📜</span>License</h2>
<p>This project is open source and provided "as is" without warranty. Use at your own risk.</p>

<h2><span style="font-size: 20px; margin-right: 10px;">📧</span>Contact</h2>
<p>Discord: bitmasterxor</p>

<p align="center">Made with ❤️ by BitmasterXor, using Delphi RAD Studio</p>
