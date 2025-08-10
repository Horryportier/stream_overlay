use rtmp::rtmp::RtmpServer;

use {anyhow::Result, streamhub::StreamsHub};

fn start_single_server() {
    let mut stream_hub = StreamsHub::new(None);
    let sender = stream_hub.get_hub_event_sender();

    let listen_port = 1935;
    let address = format!("0.0.0.0:{port}", port = listen_port);
    println!("{}", address);
    let mut rtmp_server = RtmpServer::new(address, sender, 1, None);
    tokio::spawn(async move {
        if let Err(err) = rtmp_server.run().await {
            log::error!("rtmp server error: {}\n", err);
        }
    });

    tokio::spawn(async move { stream_hub.run().await });
}

#[tokio::main]
async fn main() -> Result<()> {
    start_single_server();
    //start_cluster();
    tokio::signal::ctrl_c().await?;
    Ok(())
}
