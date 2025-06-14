function reloadGUI() {
    $.ajax({
        method: "POST",
        url: "/HandMadeStore/log",
        data: {
            action: "getAllLogs"
        },
        success: function (response) {
            let parentDocument = window.parent.document;
            let htmlLogs = parentDocument.getElementById('logs');
            if (htmlLogs) {
                let htmlLog = '';
                response.forEach(function (r) {
                    let icon = (r.level == 'INFORM') ? `<i class="text-info fa-solid fa-info"></i>` :
                        (r.level == 'ALERT') ? `<i class="text-info fa-solid fa-circle-info"></i>` :
                            (r.level == 'WARNING') ? `<i class="text-warning fa-solid fa-triangle-exclamation"></i>` :
                                (r.level == 'DANGER') ? `<i class="text-danger fa-solid fa-circle-exclamation"></i>` : ``;
                    htmlLog += `
                    <div class="dropdown-item">
                        <div class="d-flex align-items-center">
                            <div class="fs-5">
                                ${icon}
                            </div>
                            <div class="ms-2">
                                <h6 style="text-wrap: initial" class="fw-normal mb-0">${r.message}</h6>
                                <small style="color: rgb(128,128,128)">${r.formattedCreatedTime}</small>
                            </div>
                        </div>
                    </div>
                    <hr class="dropdown-divider">
                    `;
                });
                htmlLog += `
                     <a href="admin?func=logs"
                           class="dropdown-item text-center">Xem tất cả</a>
                `
                htmlLogs.innerHTML = htmlLog;
            }
        },
        error: function () {
            console.log("reload logs failed");
        }
    });
}
